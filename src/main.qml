
import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0

import Process 1.0
import Request 1.0


Window {
    id: mainLayout
    title: "Lightube"
    minimumWidth: 750
    minimumHeight: 400

    // Version
    property string version: "2018.10.01"

    // Variables
    property int totalResults: 0

    // Settings
    Settings {
      id: settings
      property int windowWidth: 700
      property int windowHeight: 400
      property string searchResults: "25"
      property string searchSite: "YouTube"
      property string searchSafe: "No"
      property string searchSort: "Relevance"
      property string searchChannel: "No"
      property string application: "mpv"
      property string arguments: "--ytdl=yes --fs"
    }

    // Process
    Process {
      id: process
    }

    // Request
    Request {
      id: request
    }

    // Search
    Rectangle {
      id: searchLayout
      color: "#F1F1F1"
      width: mainLayout.width
      height: 100
      z: 1
      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
	  width: 150
	  height: 40
	  color: "#F1F1F1"
	  Image {
	    source: "images/logo.png"
	    anchors.verticalCenter: parent.verticalCenter
	    anchors.horizontalCenter: parent.horizontalCenter
	  }
	}
	Rectangle {
	  color: "#FFFFFF"
	  border.width: 1
	  border.color: "#E1E1E1"
	  width: Math.floor(mainLayout.width * 70 / 100)
	  height: 40
	  TextInput {
	    id: searchInput
	    text: "funny cats"
	    padding: 10
	    anchors.fill: parent
	    selectByMouse: true
	  }
	}
	Rectangle {
	  color: "#FFFFFF"
	  border.width: 1
	  border.color: "#E1E1E1"
	  width: 40
	  height: 40
	  Image {
	    source: "images/search.png"
	    anchors.verticalCenter: parent.verticalCenter
	    anchors.horizontalCenter: parent.horizontalCenter
	    MouseArea {
	      cursorShape: Qt.PointingHandCursor
	      anchors.fill: parent
	      onClicked: {
		searchLayout.height = 100
		optionsButton.visible = true
		if (!resultsLayout.visible) {
		  optionsLayout.visible = false
		  resultsLayout.visible = true
		  optionsImage.source = "images/down.png"
		}
		search()
	      }
	    }
	  }
	}
	Rectangle {
	  id: optionsButton
	  visible: false
	  color: "#FFFFFF"
	  border.width: 1
	  border.color: "#E1E1E1"
	  width: 40
	  height: 40
	  Image {
	    id: optionsImage
	    source: "images/down.png"
	    anchors.verticalCenter: parent.verticalCenter
	    anchors.horizontalCenter: parent.horizontalCenter
	    MouseArea {
	      cursorShape: Qt.PointingHandCursor
	      anchors.fill: parent
	      onClicked: {
		if (parent.source.toString().indexOf("images/down.png") != -1) {
		  parent.source = "images/up.png"
		  optionsLayout.visible = true
		  resultsLayout.visible = false
		}
		else {
		  parent.source = "images/down.png"
		  optionsLayout.visible = false
		  resultsLayout.visible = true
		}
	      }
	    }
	  }
	}
      }
    }

    // Options
    Rectangle {
      id: optionsLayout
      color: "#F1F1F1"
      width: mainLayout.width
      height: mainLayout.height - searchLayout.height
      anchors.top: searchLayout.bottom
      Flickable {
	anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: optionsList.height
	Column {
	  id: optionsList
	  anchors.horizontalCenter: parent.horizontalCenter
	  padding: 10
	  spacing: 5
	  // Options: Search
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    anchors.left: parent.left
	    border.width: 1
	    border.color: "#DDDDDD"
	    Text {
	      text: "Search:"
	      font.pixelSize: 22
	      font.bold: true
	      color: "#999999"
	      verticalAlignment: Text.AlignVCenter
	      anchors.fill: parent
	      leftPadding: 15
	    }
	  }
	  // Options: Site
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Site"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		ComboBox {
		  id: siteInput
		  model: ["YouTube", "Dailymotion", "Vimeo"]
		  anchors.fill: parent
		}
	      }
	    }
	  }
	  // Options: Results
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Results"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		TextInput {
		  id: resultsInput
		  text: "25"
		  padding: 10
		  anchors.fill: parent
		  selectByMouse: true
		  clip: true
		}
	      }
	    }
	  }
	  // Options: Safe
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Safe"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		ComboBox {
		  id: safeInput
		  model: ["No", "Yes"]
		  anchors.fill: parent
		}
	      }
	    }
	  }
	  // Options: Sort
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Sort"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		ComboBox {
		  id: sortInput
		  model: ["Relevance", "Date", "Views", "Rating", "Alphabetical"]
		  anchors.fill: parent
		}
	      }
	    }
	  }
	  // Options: Channel
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Channel"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		ComboBox {
		  id: channelInput
		  model: ["No", "Yes"]
		  anchors.fill: parent
		}
	      }
	    }
	  }
	  // Options: Open
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    anchors.left: parent.left
	    border.width: 1
	    border.color: "#DDDDDD"
	    Text {
	      text: "Open:"
	      font.pixelSize: 22
	      font.bold: true
	      color: "#999999"
	      verticalAlignment: Text.AlignVCenter
	      anchors.fill: parent
	      leftPadding: 15
	    }
	  }
	  // Options: Application
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Application"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		TextInput {
		  id: applicationInput
		  text: application
		  padding: 10
		  anchors.fill: parent
		  selectByMouse: true
		  clip: true
		}
	      }
	    }
	  }
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Arguments"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#FFFFFF"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		TextInput {
		  id: argumentsInput
		  text: arguments
		  padding: 10
		  anchors.fill: parent
		  selectByMouse: true
		  clip: true
		}
	      }
	    }
	  }
	  // About
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    anchors.left: parent.left
	    border.width: 1
	    border.color: "#DDDDDD"
	    Text {
	      text: "About:"
	      font.pixelSize: 22
	      font.bold: true
	      color: "#999999"
	      verticalAlignment: Text.AlignVCenter
	      anchors.fill: parent
	      leftPadding: 15
	    }
	  }
	  // About: Version
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Version"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#F1F1F1"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		Text {
		  text: version
		  padding: 10
		  anchors.fill: parent
		  clip: true
		}
	      }
	    }
	  }
	  // About: Site
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Site"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#F1F1F1"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		Text {
		  text: "<a href=\"http://sebaro.pro/lightube\" style=\"text-decoration:none;color:#0AAFC3;font-size:12px;\">http://sebaro.pro/lightube</a>"
		  padding: 10
		  anchors.fill: parent
		  clip: true
		  textFormat: Text.RichText
		  onLinkActivated: Qt.openUrlExternally(link)
		  MouseArea {
		    anchors.fill: parent
		    acceptedButtons: Qt.NoButton
		    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
		  }
		}
	      }
	    }
	  }
	  // About: Git
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    Row {
	      padding: 10
	      spacing: 50
	      anchors.verticalCenter: parent.verticalCenter
	      anchors.horizontalCenter: parent.horizontalCenter
	      Rectangle {
		color: "#F1F1F1"
		width: 100
		height: 40
		Text {
		  text: "Git"
		  font.pixelSize: 16
		  anchors.verticalCenter: parent.verticalCenter
		}
	      }
	      Rectangle {
		color: "#F1F1F1"
		border.width: 1
		border.color: "#E1E1E1"
		width: 400
		height: 40
		Text {
		  text: "<a href=\"https://gitlab.com/sebaro/lightube\" style=\"text-decoration:none;color:#0AAFC3;font-size:12px;\">https://gitlab.com/sebaro/lightube</a>"
		  padding: 10
		  anchors.fill: parent
		  clip: true
		  textFormat: Text.RichText
		  onLinkActivated: Qt.openUrlExternally(link)
		  MouseArea {
		    anchors.fill: parent
		    acceptedButtons: Qt.NoButton
		    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
		  }
		}
	      }
	    }
	  }
	}
      }
    }

    // Results
    Rectangle {
      id: resultsLayout
      visible: false
      width: mainLayout.width
      height: mainLayout.height - searchLayout.height
      anchors.top: searchLayout.bottom
      GridView {
	id: resultsGrid
	cellWidth: mainLayout.width/Math.floor(mainLayout.width/250)
	cellHeight: ((mainLayout.width/Math.floor(mainLayout.width/250))*9)/16 + 80
	anchors.fill: parent
	model: ListModel {
	  id: gridModel
	}
	delegate:
	  Column {
	    spacing: 10
	    padding: 10
	    Image {
	      source: videoThumbnail
	      state: videoLink
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      height: ((mainLayout.width/Math.floor(mainLayout.width/250) - 20)*9)/16
	      sourceSize.width: 640
	      sourceSize.height: 360
	      MouseArea {
		cursorShape: Qt.PointingHandCursor
		anchors.fill: parent
		onClicked: {
		  open(parent.state);
		}
	      }
	    }
	    Text {
	      text: videoTitle
	      state: videoLink
	      elide: Text.ElideRight
	      clip: true
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      maximumLineCount: 2
	      wrapMode: Text.WordWrap
	      font.bold: true
	      color: "#555555"
	      MouseArea {
		cursorShape: Qt.PointingHandCursor
		anchors.fill: parent
		hoverEnabled: true
		onClicked: {
		  open(parent.state);
		}
		onEntered: {
		  parent.color = "#000000"
		}
		onExited: {
		  parent.color = "#555555"
		}
	      }
	    }
	    Text {
	      text: channelTitle
	      state: channelID
	      elide: Text.ElideRight
	      clip: true
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      maximumLineCount: 1
	      wrapMode: Text.WordWrap
	      color: "#777777"
	      MouseArea {
		cursorShape: Qt.PointingHandCursor
		anchors.fill: parent
		hoverEnabled: true
		onClicked: {
		  search(parent.state);
		}
		onEntered: {
		  parent.color = "#000000"
		}
		onExited: {
		  parent.color = "#777777"
		}
	      }
	    }
	  }
      }
    }

    function open(url) {
      var app = applicationInput.text;
      var args = argumentsInput.text.split(' ');
      args.push(url);
      process.start(app, args);
    }

    function search(channel) {
      if (!channel && !searchInput.text) return;
      //console.log('>>> Search...');
      totalResults = 0;
      gridModel.clear();
      if (siteInput.currentText == 'YouTube') searchYouTube(channel, null);
      else if (siteInput.currentText == 'Dailymotion') searchDailymotion(channel, 'page', 1);
      else if (siteInput.currentText == 'Vimeo') searchVimeo(channel, 1, null);
    }

    // YouTube
    function searchYouTube(channel, pageToken) {
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
      //console.log(url)
      xhrequest.open('GET', url, true);
      xhrequest.onreadystatechange = function() {
	if (xhrequest.readyState === XMLHttpRequest.DONE) {
	  if (xhrequest.status && xhrequest.status === 200) {
	    var result = JSON.parse(xhrequest.responseText);
	    for (var i = 0; i < result.items.length; i++) {
	      gridModel.append({
		"videoThumbnail": result.items[i].snippet.thumbnails.medium.url,
		"videoLink": "https://www.youtube.com/watch?v=" + result.items[i].id.videoId,
		"videoTitle": result.items[i].snippet.title,
		"channelTitle": result.items[i].snippet.channelTitle,
		"channelID": result.items[i].snippet.channelId,
	      });
	      totalResults++;
	      if (totalResults == resultsInput.text) break;
	    }
	    if (totalResults < result.pageInfo.totalResults && totalResults < resultsInput.text) {
	      searchYouTube(channel, result.nextPageToken);
	    }
	  }
	  else {
	    console.log("HTTP:", xhrequest.status, xhrequest.statusText);
	  }
	}
      }
      xhrequest.send();
    }

    // Dailymotion
    function searchDailymotion(channel, type, value) {
      var xhrequest = new XMLHttpRequest();
      var url;
      if (type == 'page') {
	url = 'https://api.dailymotion.com/videos?limit=20';
	// Safe N/A?
	// Sort
	if (sortInput.currentText == 'Relevance') {
	  if (channel) {
	    if (channelInput.currentText == 'Yes' && searchInput.text) url += "&sort=relevance";
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
	  if (channelInput.currentText == 'Yes' && searchInput.text) url += '&search=' + searchInput.text;
	}
	else {
	  url += '&search=' + searchInput.text;
	}
	// Page
	url += '&page=' + value;
      }
      else {
	url = 'https://api.dailymotion.com/video/' + value + '?fields=title,thumbnail_480_url,owner,owner.screenname';
      }
      //console.log(url)
      xhrequest.open('GET', url, true);
      xhrequest.onreadystatechange = function() {
	if (xhrequest.readyState === XMLHttpRequest.DONE) {
	  if (xhrequest.status && xhrequest.status === 200) {
	    var result = JSON.parse(xhrequest.responseText);
	    if (type == 'page') {
	      for (var i = 0; i < result.list.length; i++) {
		searchDailymotion(channel, 'video', result.list[i].id);
		totalResults++;
		if (totalResults == resultsInput.text) break;
	      }
	      if (totalResults < result.total && totalResults < resultsInput.text) {
		value++
		searchDailymotion(channel, 'page', value);
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
	    console.log("HTTP:", xhrequest.status, xhrequest.statusText);
	  }
	}
      }
      xhrequest.send();
    }

    // Vimeo
    function searchVimeo(channel, page, token) {
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
	  if (channelInput.currentText == 'Yes' && searchInput.text) url += '&query=' + searchInput.text;
	}
	else {
	  url += '&query=' + searchInput.text;
	}
	// Page
	url += '&page=' + page;
	//console.log(url)
	xhrequest.open('GET', url, true);
	xhrequest.setRequestHeader('authorization', 'jwt ' + token);
      }
      else {
	url = "https://vimeo.com/search?q=music";
	//console.log(url)
	request.send(url, {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.75 Safari/537.36'});
	request.response.connect(function(result) {
	  if (!token) {
	    var tokenMatch = result.match(/"jwt":"(.*?)"/);
	    token = (tokenMatch) ? tokenMatch[1] : null;
	    if (token) searchVimeo(channel, 1, token);
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
	      searchVimeo(channel, page, token);
	    }
	  }
	  else {
	    console.log("HTTP:", xhrequest.status, xhrequest.statusText);
	  }
	}
      }
      xhrequest.send();
    }

    Component.onCompleted: {
      mainLayout.width = settings.windowWidth
      mainLayout.height = settings.windowHeight
      siteInput.currentIndex = siteInput.model.indexOf(settings.searchSite)
      resultsInput.text = settings.searchResults
      safeInput.currentIndex = safeInput.model.indexOf(settings.searchSafe)
      sortInput.currentIndex = sortInput.model.indexOf(settings.searchSort)
      channelInput.currentIndex = channelInput.model.indexOf(settings.searchChannel)
      applicationInput.text = settings.application
      argumentsInput.text = settings.arguments
    }

    Component.onDestruction: {
      settings.windowWidth = mainLayout.width
      settings.windowHeight = mainLayout.height
      settings.searchSite = siteInput.currentText
      settings.searchResults = resultsInput.text
      settings.searchSafe = safeInput.currentText
      settings.searchSort = sortInput.currentText
      settings.searchChannel = channelInput.currentText
      settings.application = applicationInput.text
      settings.arguments = argumentsInput.text
    }
}
