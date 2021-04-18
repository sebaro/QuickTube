/*
 *
 * YouTube
 *
 */


function search(channel, params) {
	var xhrequest = new XMLHttpRequest();
	if (!params) {
		params = {};
		params['continuation'] = null;
		xhrequest.open('GET', 'https://www.youtube.com', true);
		xhrequest.onreadystatechange = function() {
			if (xhrequest.readyState === XMLHttpRequest.DONE) {
				if (xhrequest.status && xhrequest.status === 200) {
					var parser = xhrequest.responseText.match('"INNERTUBE_API_KEY":"(.*?)"');
					params['api_key'] = (parser) ? parser[1] : null;
					parser = xhrequest.responseText.match('"INNERTUBE_CLIENT_VERSION":"(.*?)"');
					params['client_version'] = (parser) ? parser[1] : null;
					search(channel, params);
				}
				else {
					if (debug) console.log('XHR Error: '  + '\n', 'URL: ' + url + '\n', 'Status: ' + xhrequest.status + '\n', 'StatusText: ' + xhrequest.statusText + '\n');
				}
			}
		}
		xhrequest.send();
	}
	else {
		var url, data, json, contents, renderer;
		var results = 0;
		// Query: Search/List
		var query = (channel) ? ((channelInput.currentText == 'Yes') ? 'search' : 'list') : 'search';
		// Safe
		var	safe = (safeInput.currentText == 'Yes') ? true : false;
		// Sort
		var sort = 'EgZzZWFyY2g%3D';
		if (sortInput.currentText == 'Relevance') {
			if (channel) {
				if (query == 'list') {
					sort = 'EgZ2aWRlb3M%3D';
				}
			}
			else {
				sort = 'CAA';
			}
		}
		else if (sortInput.currentText == 'Date') {
			if (channel) {
				if (query == 'list') {
					sort = 'EgZ2aWRlb3M%3D';
				}
			}
			else {
				sort = 'CAI';
			}
		}
		else if (sortInput.currentText == 'Views') {
			if (channel) {
				if (query == 'list') {
					sort = 'EgZ2aWRlb3MYAiAAMAE%3D';
				}
			}
			else {
				sort = 'CAM';
			}
		}
		else if (sortInput.currentText == 'Rating') {
			if (channel) {
				if (query == 'list') {
					sort = 'EgZ2aWRlb3MYASAAMAE%3D';
				}
			}
			else {
				sort = 'CAE';
			}
		}
		else if (sortInput.currentText == 'Alphabetical') {
			if (channel) {
				if (query == 'list') {
					sort = 'EgZ2aWRlb3M%3D';
				}
			}
			else {
				sort = 'CAI';
			}
		}
		if (channel) {
			url = 'https://www.youtube.com/youtubei/v1/browse?key=' + params['api_key'];
		}
		else {
			url = 'https://www.youtube.com/youtubei/v1/search?key=' + params['api_key'];
		}
		data = '{"context":{"client":{"clientName":"WEB","clientVersion":"' + params['client_version'] + '"}},"user":{"enableSafetyMode":' + safe + ',"lockedSafetyMode":false},';
		if (params['continuation']) {
			data += '"continuation":"' + params['continuation'] + '"}';
		}
		else {
			if (channel) {
				if (query == 'list') {
					data += '"browseId":"' + channel + '","params":"' + sort + '"}'
				}
				else {
					data += '"browseId":"' + channel + '","params":"' + sort + '","query":"' + searchInput.text + '"}'
				}
			}
			else {
				data += '"params":"' + sort + '","query":"' + searchInput.text + '"}'
			}
		}
		if (debug) {
			console.log(url);
			console.log(data);
		}
		xhrequest.open('POST', url, true);
		xhrequest.setRequestHeader('content-type', 'application/json;charset=UTF-8');
		//xhrequest.setRequestHeader('user-agent', 'curl/7.72.0');
		xhrequest.onreadystatechange = function() {
			if (xhrequest.readyState === XMLHttpRequest.DONE) {
				if (xhrequest.status && xhrequest.status === 200) {
					json = JSON.parse(xhrequest.responseText);
					contents = [];
					if (json && json.contents) {
						if (channel) {
							if (query == 'list') {
								contents = json.contents.twoColumnBrowseResultsRenderer.tabs[1].tabRenderer.content.sectionListRenderer.contents[0].itemSectionRenderer.contents[0].gridRenderer.items;
							}
							else {
								contents = json.contents.twoColumnBrowseResultsRenderer.tabs[6].expandableTabRenderer.content.sectionListRenderer.contents;
							}
							params['channel_title'] = json.metadata.channelMetadataRenderer.title;
						}
						else {
							contents = json.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents;
							if (contents.length == 2) {
								contents = contents[0].itemSectionRenderer.contents;
							}
							else {
								contents = contents[1].itemSectionRenderer.contents;
							}
						}
					}
					else if (json && json.onResponseReceivedCommands) {
						if (channel) {
							contents = json.onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems;
						}
						else {
							contents = json.onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems[0].itemSectionRenderer.contents;
						}
					}
					if (contents) {
						for (var i = 0; i < contents.length; i++) {
							if (channel) {
								if (query == 'list') {
									renderer = contents[i].gridVideoRenderer;
								}
								else {
									renderer = contents[i].itemSectionRenderer.contents[0].videoRenderer;
								}
							}
							else {
								renderer = contents[i].videoRenderer;
							}
							if (renderer) {
								if (debug) {
									console.log(i);
									console.log(renderer.videoId);
									console.log(renderer.thumbnail.thumbnails);
									console.log(renderer.title.runs[0].text);
									if (channel) {
										console.log(params['channel_title']);
										console.log(channel);
									}
									else {
										console.log(renderer.ownerText.runs[0].text);
										console.log(renderer.ownerText.runs[0].navigationEndpoint.browseEndpoint.browseId);
									}
								}
								gridModel.append({
									'videoThumbnail': (renderer.thumbnail.thumbnails[1]) ? renderer.thumbnail.thumbnails[1].url : renderer.thumbnail.thumbnails[0].url,
									'videoLink': 'https://www.youtube.com/watch?v=' + renderer.videoId,
									'videoTitle': renderer.title.runs[0].text.replace(/&#39;/g, '\'').replace(/&amp;/g, '&').replace(/&quot;/g, '"'),
									'channelTitle': (renderer.ownerText) ? renderer.ownerText.runs[0].text : params['channel_title'],
									'channelID': (renderer.ownerText) ? renderer.ownerText.runs[0].navigationEndpoint.browseEndpoint.browseId : channel
								});
								totalResults++;
								if (totalResults == resultsInput.text) break;
							}
						}
						if (channel) {
							results = totalResults + (contents.length - 1);
						}
						else {
							results = json.estimatedResults;
						}
						if (debug) console.log(results + ' : ' + totalResults);
					}
					if (totalResults < results && totalResults < resultsInput.text) {
						if (json && json.contents) {
							if (channel) {
								if (query == 'list') {
									contents = json.contents.twoColumnBrowseResultsRenderer.tabs[1].tabRenderer.content.sectionListRenderer.contents[0].itemSectionRenderer.contents[0].gridRenderer.items[30];
								}
								else {
									contents = json.contents.twoColumnBrowseResultsRenderer.tabs[6].expandableTabRenderer.content.sectionListRenderer.contents[30];
								}
							}
							else {
								contents = json.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents;
								if (contents.length == 2) {
									contents = contents[1];
								}
								else {
									contents = contents[2];
								}
							}
						}
						else if (json && json.onResponseReceivedCommands) {
							if (channel) {
								contents = json.onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems[30];
							}
							else {
								contents = json.onResponseReceivedCommands[0].appendContinuationItemsAction.continuationItems[1];
							}
						}
						params['continuation'] = contents.continuationItemRenderer.continuationEndpoint.continuationCommand.token;
						search(channel, params);
					}
				}
				else {
					if (debug) console.log('XHR Error: '  + '\n', 'URL: ' + url + '\n', 'Status: ' + xhrequest.status + '\n', 'StatusText: ' + xhrequest.statusText + '\n');
				}
			}
		}
		xhrequest.send(data);
	}
}

function stream(video, callback) {
	var streams, stream, script, parser;
	var live = false;
	function clean(content, unesc) {
		if (unesc) content = unescape(content);
		content = content.replace(/\\u0025/g, '%').replace(/\\u0026/g, '&').replace(/\\u002F/g, '/');
		content = content.replace(/&amp;/g, '&');
		content = content.replace(/\\/g, '').replace(/\n/g, '');
		return content;
	}
	function parse(content, pattern, clean) {
		if (clean) content = clean(content, true);
		var parser = content.match(pattern);
		return (parser) ? parser[1] : null;
	}
	function request(action, url) {
		var xhrequest = new XMLHttpRequest();
		xhrequest.open('GET', url, true);
		xhrequest.onreadystatechange = function() {
			if (xhrequest.readyState === XMLHttpRequest.DONE) {
				if (xhrequest.status && xhrequest.status === 200) {
					process(action, url, xhrequest.responseText);
				}
				else {
					if (debug) console.log('XHR Error: '  + '\n', 'URL: ' + url + '\n', 'Status: ' + xhrequest.status + '\n', 'StatusTest: ' + xhrequest.statusText + '\n');
				}
			}
		}
		xhrequest.send();
	}
	function process(action, url, data) {
		if (action == 'streams') {
			if (url.indexOf('/watch') != -1) {
				streams = parse(data, '"url_encoded_fmt_stream_map\\\\?":\\s*\\\\?"(.*?)\\\\?"', false);
				if (!streams) {
					streams = parse(data, '"formats\\\\?":\\s*(\\[.*?\\])', false);
					if (streams) {
						streams = clean(streams, false);
						parser = streams.match(new RegExp('"(url|cipher|signatureCipher)":\s*".*?"', 'g'));
						if (parser) {
							streams = '';
							for (var i = 0 ; i < parser.length; i++) {
								streams += parser[i].replace(/"/g, '').replace('url:', 'url=').replace('cipher:', '').replace('signatureCipher:', '') + ','
							}
							if (streams.indexOf('itag%3D') != -1) {
								streams = clean(streams, true);
							}
						}
					}
				}
				if (!streams) {
					streams = parse(data, '"hls(?:vp|ManifestUrl)\\\\?":\\s*\\\\?"(.*?)\\\\?"', false);
					if (streams) live = true;
				}
				script = parse(data, '"js":\\s*"(.*?)"', false);
				if (script) {
					script = clean(script, false);
					script = 'https://www.youtube.com' + script;
					if (debug) console.log('Script from page: ' + '\n' + script + '\n');
				}
			}
			else if (url.indexOf('/get_video_info') != -1) {
				streams = parse(data, 'url_encoded_fmt_stream_map=(.*?)&', false);
				if ( streams) {
					streams = clean(streams, true);
				}
				else {
					streams = parse(data, 'formats%22%3A(%5B.*?%5D)', false);
					if (streams) {
						streams = clean(streams, true);
						parser = streams.match(new RegExp('"(url|cipher|signatureCipher)":\s*".*?"', 'g'));
						if (parser) {
							streams = '';
							for (var i = 0 ; i < parser.length; i++) {
								streams += parser[i].replace(/"/g, '').replace('url:', 'url=').replace('cipher:', '').replace('signatureCipher:', '') + ','
							}
							if (streams.indexOf('itag%3D') != -1) {
								streams = clean(streams, true);
							}
						}
					}
				}
			}
			if (!streams) {
				if (url.indexOf('/watch') != -1) {
					request('streams', video.replace(/watch\?v/, 'get_video_info?video_id') + '&eurl=https://youtube.googleapis.com/v/');
				}
			}
			else {
				if (live) {
					stream = clean(streams, false);
					callback(stream);
				}
				else {
					if (debug) console.log('Streams: ' + '\n' + streams + '\n');
					streams = streams.split(',');
					var itag;
					for (var i = 0; i < streams.length; i++) {
						if (!streams[i].match(/^url/)) {
							parser = streams[i].match(/(.*)(url=.*$)/);
							if (parser) streams[i] = parser[2] + '&' + parser[1];
						}
						parser = streams[i].match(/itag=(\d{1,3})/);
						itag = (parser) ? parser[1] : null;
						if (itag == '22' || itag == '18') {
							if (stream) continue;
							stream = clean(streams[i], true);
							stream = stream.replace(/url=/, '').replace(/&$/, '');
							if (debug) console.log('Stream: ' + '\n' + stream + '\n');
							if (stream.match(/itag=/) && stream.match(/itag=/g).length > 1) {
								if (stream.match(/itag=\d{1,3}&/)) stream = stream.replace(/itag=\d{1,3}&/, '');
								else if (stream.match(/&itag=\d{1,3}/)) stream = stream.replace(/&itag=\d{1,3}/, '');
							}
							if (stream.match(/clen=/) && stream.match(/clen=/g).length > 1) {
								if (stream.match(/clen=\d+&/)) stream = stream.replace(/clen=\d+&/, '');
								else if (stream.match(/&clen=\d+/)) stream = stream.replace(/&clen=\d+/, '');
							}
							if (stream.match(/lmt=/) && stream.match(/lmt=/g).length > 1) {
								if (stream.match(/lmt=\d+&/)) stream = stream.replace(/lmt=\d+&/, '');
								else if (stream.match(/&lmt=\d+/)) stream = stream.replace(/&lmt=\d+/, '');
							}
							if (stream.match(/type=(video|audio).*?&/)) stream = stream.replace(/type=(video|audio).*?&/, '');
							else stream = stream.replace(/&type=(video|audio).*$/, '');
							if (stream.match(/xtags=[^%=]*&/)) stream = stream.replace(/xtags=[^%=]*?&/, '');
							else if (stream.match(/&xtags=[^%=]*$/)) stream = stream.replace(/&xtags=[^%=]*$/, '');
							if (stream.match(/&sig=/) && !stream.match(/&lsig=/)) stream = stream.replace(/&sig=/, '&signature=');
							stream = clean(stream, true);
							if (stream.indexOf('ratebypass') == -1) stream += '&ratebypass=yes';
						}
					}
					if (stream && stream.indexOf('http') == 0) {
						if (stream.match(/&s=/)) {
							if (script) request('signature', script);
							else request('script', video.replace(/watch\?v=/, 'embed/'));
						}
						else {
							callback(stream);
						}
					}
				}
			}
		}
		else if (action == 'script') {
			script = parse(data, '"js(?:Url)?":\\s*"(.*?)"', false);
			if (script) {
				script = clean(script, false);
				script = 'https://www.youtube.com' + script;
				request('signature', script);
				if (debug) console.log('Script from embed: ' + '\n' + script + '\n');
			}
		}
		else if (action == 'signature') {
			function signdec(s) {return null;}
			var signfn, signfb, swapfn, swapfb, funcm, signv, signp;
			data = data.replace(/(\r\n|\n|\r)/gm, '');
			signfn = data.match(/"signature"\s*,\s*([^\)]*?)\(/);
			if (!signfn) signfn = data.match(/c&&.\.set\(b,(?:encodeURIComponent\()?.*?([a-zA-Z0-9$]+)\(/);
			if (!signfn) signfn = data.match(/c&&\([a-zA-Z0-9$]+=([a-zA-Z0-9$]+)\(decodeURIComponent/);
			signfn = (signfn) ? signfn[1] : null;
			if (signfn) {
				funcm = ';' + signfn.replace(/\$/, '\\$') + '\\s*=\\s*function\\s*' + '\\s*\\(\\w+\\)\\s*\\{(.*?)\\}';
				signfb = data.match(funcm);
				signfb = (signfb) ? signfb[1] : null;
				if (signfb) {
					swapfn = signfb.match(/((\$|_|\w)+)\.(\$|_|\w)+\(\w,[0-9]+\)/);
					swapfn = (swapfn) ? swapfn[1] : null;
					if (swapfn) {
						funcm = 'var\\s+' + swapfn.replace(/\$/, '\\$') + '=\\s*\\{(.*?)\\};';
						swapfb = data.match(funcm);
						swapfb = (swapfb) ? swapfb[1] : null;
					}
					if (swapfb) signfb = 'var ' + swapfn + '={' + swapfb + '};' + signfb;
					signfb = 'try {' + signfb + '} catch(e) {return null}';
					signdec = new Function('a', signfb);
					signv = stream.match(/&s=(.*?)(&|$)/);
					signv = (signv) ? signv[1] : null;
					if (signv) {
						signv = signdec(signv);
						if (signv) {
							signp = stream.match(/&sp=(.*?)(&|$)/);
							signp = (signp) ? signp[1] : ((stream.match(/&lsig=/)) ? 'sig' : 'signature');
							stream = stream.replace(/&s=.*?(&|$)/, '&' + signp + '=' + signv + '$1');
							callback(stream);
						}
						else stream = '';
					}
					else stream = '';
				}
			}
		}
	}
	request('streams', video);
}

function test() {
	console.log('YouTube Test:');
	//-SIG https://www.youtube.com/watch?v=8Mla_P76Sv0
	//-SIG https://www.youtube.com/watch?v=IxkmW-MVBAY
	//+SIG https://www.youtube.com/watch?v=yXQViqx6GMY
	//AGER https://www.youtube.com/watch?v=Fy6TsNNoL3w
	//AGER https://www.youtube.com/watch?v=c8Q77saURbE
	//AGER https://www.youtube.com/watch?v=evDAi77IDhY
	//LIVE https://www.youtube.com/watch?v=hHW1oY26kxQ
	stream('https://www.youtube.com/watch?v=c8Q77saURbE', function(data) {
		console.log('Stream: ' + '\n' + data + '\n');
	});
}
//test();
