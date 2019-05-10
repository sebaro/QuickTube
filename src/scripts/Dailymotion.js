/*
 *
 * Dailymotion
 *
 */


function search(channel, type, value) {
  var xhrequest = new XMLHttpRequest();
  var url;
  if (type == 'page') {
    url = 'https://api.dailymotion.com/videos?limit=20';
    // Safe N/A?
    // Sort
    if (sortInput.currentText == 'Relevance') {
      if (channel) {
	if (channelInput.currentText == 'Yes' && searchWidget.searchInput.text) url += "&sort=relevance";
	else url += "&sort=recent";
      }
      else {
	url += "&sort=relevance";
      }
    }
    else if (sortInput.currentText == 'Date') url += "&sort=recent";
    else if (sortInput.currentText == 'Views') url += "&sort=visited";
    else if (sortInput.currentText == 'Rating') url += "&sort=trending";
    else if (sortInput.currentText == 'Alphabetical') url += "&sort=recent";
    // Channel
    if (channel) {
      url += "&owners=" + channel;
      if (channelInput.currentText == 'Yes' && searchWidget.searchInput.text) url += '&search=' + searchWidget.searchInput.text;
    }
    else {
      url += '&search=' + searchWidget.searchInput.text;
    }
    // Page
    url += '&page=' + value;
  }
  else {
    url = 'https://api.dailymotion.com/video/' + value + '?fields=title,thumbnail_480_url,owner,owner.screenname';
  }
  if (debug) console.log('Search URL: ' + '\n' + url + '\n');
  xhrequest.open('GET', url, true);
  xhrequest.onreadystatechange = function() {
    if (xhrequest.readyState === XMLHttpRequest.DONE) {
      if (xhrequest.status && xhrequest.status === 200) {
	var result = JSON.parse(xhrequest.responseText);
	if (type == 'page') {
	  for (var i = 0; i < result.list.length; i++) {
	    search(channel, 'video', result.list[i].id);
	    totalResults++;
	    if (totalResults == resultsInput.text) break;
	  }
	  if (totalResults < result.total && totalResults < resultsInput.text) {
	    value++
	    search(channel, 'page', value);
	  }
	}
	else {
	  gridModel.append({
	    "videoThumbnail": result.thumbnail_480_url,
	    "videoLink": "https://www.dailymotion.com/video/" + value,
	    "videoTitle": result.title,
	    "channelTitle": result['owner.screenname'],
	    "channelID": result.owner
	  });
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
  var streams, stream;
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
      streams = parse(data, '"qualities":\\{(.*?)\\]\\},', false);
      if (streams) {
	if (debug) console.log('Streams: ' + '\n' + streams + '\n');
	var qualities = ['1080', '720', '480', '380'];
	var pattern, parser;
	for (var i = 0; i < qualities.length; i++) {
	  pattern = '"' + qualities[i] + '".*?"type":"video.*?mp4","url":"(.*?)"';
	  parser = streams.match(pattern);
	  stream = (parser) ? parser[1] : null;
	  if (stream) {
	    stream = clean(stream, false);
	    callback(stream);
	    break;
	  }
	}
	if (!stream) {
	  for (var i = 0; i < qualities.length; i++) {
	    pattern = '"' + qualities[i] + '".*?"type":"application.*?mpegURL","url":"(.*?)"';
	    parser = streams.match(pattern);
	    stream = (parser) ? parser[1] : null;
	    if (stream) {
	      stream = clean(stream, false);
	      callback(stream);
	      break;
	    }
	  }
	}
      }
    }
  }
  request('streams', video.replace(/\/video\//, "/embed/video/"));
}

function test() {
  console.log('Dailymotion Test:');
  // https://www.dailymotion.com/video/x2ryxz5
  stream('https://www.dailymotion.com/video/x2ryxz5', function(data) {
    console.log('Stream: ' + '\n' + data + '\n');
  });
}
//test();
