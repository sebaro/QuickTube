/*
 *
 * Vimeo
 *
 */


function search(channel, page, token) {
  var xhrequest = new XMLHttpRequest();
  var url;
  if (token) {
    if (channel) url = 'https://api.vimeo.com/users/' + channel + '/videos?fields=name,link,pictures.sizes,user.name,user.uri&sizes=640x360&per_page=20';
    else url = 'https://api.vimeo.com/videos?fields=name,link,pictures.sizes,user.name,user.uri&sizes=640x360&per_page=20';
    // Safe
    if (safeInput.currentText == 'Yes') url += "&filter_mature=7";
    else url += "&filter_mature=255";
    // Sort
    if (sortInput.currentText == 'Relevance') {
      if (channel) {
	url += "&sort=date";
      }
      else {
	url += "&sort=relevant";
      }
    }
    else if (sortInput.currentText == 'Date') url += "&sort=date";
    else if (sortInput.currentText == 'Views') url += "&sort=plays";
    else if (sortInput.currentText == 'Rating') url += "&sort=likes";
    else if (sortInput.currentText == 'Alphabetical') url += "&sort=alphabetical";
    // Channel
    if (channel) {
      if (channelInput.currentText == 'Yes' && searchWidget.searchInput.text) url += '&query=' + searchWidget.searchInput.text;
    }
    else {
      url += '&query=' + searchWidget.searchInput.text;
    }
    // Page
    url += '&page=' + page;
    if (debug) console.log('Search URL: ' + '\n' + url + '\n');
    xhrequest.open('GET', url, true);
    xhrequest.setRequestHeader('authorization', 'jwt ' + token);
  }
  else {
    url = "https://vimeo.com/search?q=music";
    request.send(url, {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.75 Safari/537.36'});
    request.response.connect(function(result) {
      if (!token) {
	var tokenMatch = result.match(/"jwt":"(.*?)"/);
	token = (tokenMatch) ? tokenMatch[1] : null;
	if (token) search(channel, 1, token);
      }
      return;
    });
    return;
  }
  xhrequest.onreadystatechange = function() {
    if (xhrequest.readyState === XMLHttpRequest.DONE) {
      if (xhrequest.status && xhrequest.status === 200) {
	var result = JSON.parse(xhrequest.responseText);
	for (var i = 0; i < result.data.length; i++) {
	  gridModel.append({
	    "videoThumbnail": result.data[i].pictures.sizes[0].link,
	    "videoLink": result.data[i].link,
	    "videoTitle": result.data[i].name,
	    "channelTitle": result.data[i].user.name,
	    "channelID": result.data[i].user.uri.replace(/.*\//, '')
	  });
	  totalResults++;
	  if (totalResults == resultsInput.text) break;
	}
	if (totalResults < result.total && totalResults < resultsInput.text) {
	  page++;
	  search(channel, page, token);
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
  var source, streams, stream;
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
    if (action == 'source') {
      source = parse(data, '(?:"config_url":|data-config-url=)"(.*?)"', false);
      if (source) {
	source = clean(source, false);
	if (debug) console.log('Source: ' + '\n' + source + '\n');
	request('streams', source);
      }
    }
    else if (action == 'streams') {
      streams = parse(data, '"progressive":\\[(.*?)\\]', false);
      if (streams) {
	if (debug) console.log('Streams: ' + '\n' + streams + '\n');
	var qualities = ['1080p', '720p', '480p', '360p'];
	var parser;
	var streams = streams.split('},');
	for (var i = 0; i < streams.length; i++) {
	  if (stream) break;
	  for (var j = 0; j < qualities.length; j++) {
	    if (streams[i].indexOf('"quality":"' + qualities[j] + '"') != -1) {
	      parser = streams[i].match(/"url":"(.*?)"/);
	      stream = (parser) ? parser[1] : null;
	      if (stream) {
		callback(stream);
		break;
	      }
	    }
	  }
	}
      }
    }
  }
  request('source', video);
}

function test() {
  console.log('Vimeo Test:');
  // https://vimeo.com/330968120
  stream('https://vimeo.com/330968120', function(data) {
    console.log('Stream: ' + '\n' + data + '\n');
  });
}
//test();
