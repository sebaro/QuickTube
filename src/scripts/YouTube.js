/*
 *
 * YouTube
 *
 */


function search(channel, pageToken) {
  var xhrequest = new XMLHttpRequest();
  var url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyCM5q-5xi_0La_TWRViSpV8v0nwgrIS7Ro&maxResults=20';
  // Token
  if (pageToken) url += '&pageToken=' + pageToken;
  // Safe
  if (safeInput.currentText == 'Yes') url += "&safeSearch=strict";
  else url += "&safeSearch=none";
  // Sort
  if (sortInput.currentText == 'Relevance') {
    if (channel) {
      if (channelInput.currentText == 'Yes' && searchInput.text) url += "&order=relevance";
      else url += "&order=date";
    }
    else {
      url += "&order=relevance";
    }
  }
  else if (sortInput.currentText == 'Date') url += "&order=date";
  else if (sortInput.currentText == 'Views') url += "&order=viewCount";
  else if (sortInput.currentText == 'Rating') url += "&order=rating";
  else if (sortInput.currentText == 'Alphabetical') url += "&order=title";
  // Channel
  if (channel) {
    url += "&channelId=" + channel;
    if (channelInput.currentText == 'Yes' && searchInput.text) url += '&q=' + searchInput.text;
  }
  else {
    url += '&q=' + searchInput.text;
  }
  //url = "/home/Devel/Qt/Lightube/test/searches-youtube.json";
  if (debug) console.log('Search URL: ' + '\n' + url + '\n');
  xhrequest.open('GET', url, true);
  xhrequest.onreadystatechange = function() {
    if (xhrequest.readyState === XMLHttpRequest.DONE) {
      if (xhrequest.status && xhrequest.status === 200) {
	var result = JSON.parse(xhrequest.responseText);
	for (var i = 0; i < result.items.length; i++) {
	  gridModel.append({
	    "videoThumbnail": result.items[i].snippet.thumbnails.medium.url,
	    "videoLink": "https://www.youtube.com/watch?v=" + result.items[i].id.videoId,
	    "videoTitle": result.items[i].snippet.title.replace(/&#39;/g, '\'').replace(/&amp;/g, '&'),
	    "channelTitle": result.items[i].snippet.channelTitle,
	    "channelID": result.items[i].snippet.channelId,
	  });
	  totalResults++;
	  if (totalResults == resultsInput.text) break;
	}
	if (totalResults < result.pageInfo.totalResults && totalResults < resultsInput.text) {
	  search(channel, result.nextPageToken);
	}
      }
      else {
	if (debug) console.log("XHR Error: "  + '\n' + xhrequest.status, xhrequest.statusText + '\n');
      }
    }
  }
  xhrequest.send();
}

function stream(video, callback) {
  var streams, stream, script;
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
	  if (debug) console.log("XHR Error: " + '\n' + xhrequest.status, xhrequest.statusText + '\n');
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
	streams = clean(streams, true);
      }
      if (!streams) {
	if (url.indexOf('/watch') != -1) request('streams', video.replace(/watch\?v/, 'get_video_info?video_id'));
      }
      else {
	if (live) {
	  stream = clean(streams, false);
	  callback(stream);
	}
	else {
	  if (debug) console.log('Streams: ' + '\n' + streams + '\n');
	  streams = streams.split(',');
	  var parser, itag;
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
	      if (debug) console.log('Stream: ' + '\n' + stream + '\n');
	      stream = stream.replace(/url=/, '').replace(/&$/, '');
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
	      if (stream.match(/&sig=/)) stream = stream.replace(/&sig=/, '&signature=');
	      stream = clean(stream, true);
	      if (stream.indexOf('ratebypass') == -1) stream += '&ratebypass=yes';
	    }
	  }
	  if (stream && stream.indexOf('http') == 0) {
	    if (stream.match(/&s=/)) {
	      if (script) request('signature', script);
	      else request('script', video.replace(/watch\?v=/, 'embed'));
	    }
	    else {
	      callback(stream);
	    }
	  }
	}
      }
    }
    else if (action == 'script') {
      script = parse(data, '"js":\\s*"(.*?)"', false);
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
      if (!signfn) signfn = data.match(/d.set\(b,(?:encodeURIComponent\()?.*?([a-zA-Z0-9$]+)\(/);
      signfn = (signfn) ? signfn[1] : null;
      if (signfn) {
	funcm = signfn.replace(/\$/, '\\$') + '\\s*=\\s*function\\s*' + '\\s*\\(\\w+\\)\\s*\\{(.*?)\\}';
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
	      signp = (signp) ? signp[1] : 'signature';
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
  //LIVE https://www.youtube.com/watch?v=hHW1oY26kxQ
  stream('https://www.youtube.com/watch?v=IxkmW-MVBAY', function(data) {
    console.log('Stream: ' + '\n' + data + '\n');
  });
}
//test();
