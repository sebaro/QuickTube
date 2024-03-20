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
		var query = (channel) ? ((channelInput.currentText == 'Yes') ? 'search' : 'browse') : 'search';
		// Safe
		var	safe = (safeInput.currentText == 'Yes') ? true : false;
		// Sort
		var sorts = {
			'Relevance': {'channel': {'search': 'EgZzZWFyY2g%3D', 'browse': 'EgZ2aWRlb3M%3D'}, 'videos': 'CAA'},
			'Date': {'channel': {'search': 'EgZzZWFyY2g%3D', 'browse': 'EgZ2aWRlb3M%3D'}, 'videos': 'CAI'},
			'Views': {'channel': {'search': 'EgZzZWFyY2g%3D', 'browse': 'EgZ2aWRlb3MYAiAAMAE%3D'}, 'videos': 'CAM'},
			'Rating': {'channel': {'search': 'EgZzZWFyY2g%3D', 'browse': 'EgZ2aWRlb3MYASAAMAE%3D'}, 'videos': 'CAE'},
			'Alphabetical': {'channel': {'search': 'EgZzZWFyY2g%3D', 'browse': 'EgZ2aWRlb3M%3D'}, 'videos': 'CAI'}
		};
		var sort = (channel) ? sorts[sortInput.currentText]['channel'][query] : sorts[sortInput.currentText]['videos'];
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
				if (query == 'browse') {
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
							if (query == 'browse') {
								contents = json.contents.twoColumnBrowseResultsRenderer.tabs[1].tabRenderer.content.richGridRenderer.contents;
							}
							else {
								for (var i = 0; i < json.contents.twoColumnBrowseResultsRenderer.tabs.length; i++) {
									if (json.contents.twoColumnBrowseResultsRenderer.tabs[i].expandableTabRenderer) {
										contents = json.contents.twoColumnBrowseResultsRenderer.tabs[i].expandableTabRenderer.content.sectionListRenderer.contents;
										break;
									}
								}
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
								if (query == 'browse') {
									renderer = contents[i].richItemRenderer.content.videoRenderer;
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
								if (query == 'browse') {
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
	var streams, stream, parser;
	var id = parse(video, /(?:\?|&)v=(.*?)(&|$)/);
	var purl = 'https://www.youtube.com/youtubei/v1/player?key=AIzaSyA8eiZmM1FaDVjRy-df2KTyQ_vz_yYM39w';
	var pdatas = {
		'default':{'context':{'client':{'clientName':'ANDROID','clientVersion':'19.09.37','androidSdkVersion':30}},'params':'CgIQBg==','videoId':id},
		'embed': {'context':{'client':{'clientName':'ANDROID','clientVersion':'19.09.37','clientScreen':'EMBED','androidSdkVersion':30},'thirdParty':{'embedUrl':'https://www.youtube.com'}},'params':'CgIQBg==','videoId':id}
	};
	var pdata = pdatas['default'];
	function clean(content, unesc) {
		if (unesc) content = unescape(content);
		content = content.replace(/\\u0025/g, '%').replace(/\\u0026/g, '&').replace(/\\u002F/g, '/');
		content = content.replace(/&amp;/g, '&');
		content = content.replace(/\\/g, '').replace(/\n/g, '');
		return content;
	}
	function parse(content, pattern) {
		var parser = content.match(pattern);
		return (parser) ? parser[1] : null;
	}
	function request(action, url) {
		var data = null;
		if (url.indexOf('|') != -1) {
			data = url.split('|')[1];
			url = url.split('|')[0];
		}
		if (debug) console.log('XHR Request: '  + '\n', 'URL: ' + url + '\n' + 'data: ' + data + '\n');
		var xhrequest = new XMLHttpRequest();
		if (data) {
			xhrequest.open('POST', url, true);
			xhrequest.setRequestHeader('content-type', 'application/json');
		}
		else {
			xhrequest.open('GET', url, true);
		}
		xhrequest.onreadystatechange = function() {
			if (xhrequest.readyState === XMLHttpRequest.DONE) {
				if (xhrequest.status && xhrequest.status === 200) {
					process(action, xhrequest.responseText || xhrequest.responseXML);
				}
				else {
					if (debug) console.log('XHR Error: '  + '\n', 'URL: ' + url + '\n' + 'data: ' + data + '\n', 'Status: ' + xhrequest.status + '\n', 'StatusTest: ' + xhrequest.statusText + '\n');
				}
			}
		}
		xhrequest.send(data);
	}
	function process(action, data) {
		if (action == 'fetch') {
			if (streams) {
				pdata = pdatas['embed'];
			}
			streams = request('parse', purl + '|' + JSON.stringify(pdata));
		}
		else if (action == 'parse') {
			try {
				streams = JSON.parse(data);
			}
			catch(e) {
				streams = {};
			}
			streams = (streams['streamingData']) ? streams['streamingData'] : {};
			if (!streams['formats'] && streams['hlsManifestUrl']) {
				callback(streams['hlsManifestUrl']);
			}
			else {
				if (!streams['formats']) {
					if (pdata != pdatas['embed']) {
						process('fetch');
					}
					else {
						if (debug) console.log('Error: no videos found \n');
					}
				}
				else {
					streams = streams['formats'];
					for (var i = 0; i < streams.length; i++) {
						if (streams[i]['itag'] == '18' || streams[i]['itag'] == '22') {
							stream = streams[i]['url'];
							stream = clean(stream, true);
							if (stream.indexOf('ratebypass') == -1) stream += '&ratebypass=yes';
						}
					}
					callback(stream);
				}
			}
		}
	}
	process('fetch');
}

function test() {
	console.log('YouTube Test:');
	//-SIG https://www.youtube.com/watch?v=8Mla_P76Sv0
	//-SIG https://www.youtube.com/watch?v=IxkmW-MVBAY
	//+SIG https://www.youtube.com/watch?v=yXQViqx6GMY
	//AGER https://www.youtube.com/watch?v=Fy6TsNNoL3w
	//AGER https://www.youtube.com/watch?v=c8Q77saURbE
	//AGER https://www.youtube.com/watch?v=evDAi77IDhY
	//LIVE https://www.youtube.com/watch?v=jfKfPfyJRdk
	stream('https://www.youtube.com/watch?v=yXQViqx6GMY', function(data) {
		console.log('Stream: ' + '\n' + data + '\n');
	});
}
//var debug = true;
//test();
