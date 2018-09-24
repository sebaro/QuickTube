
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
    property string version: "2018.09.24"

    // Variables
    property int totalResults: 0

    // Settings
    Settings {
      id: settings
      property int windowWidth: 700
      property int windowHeight: 400
      property int searchResults: 25
      property string searchSite: "YouTube"
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
		totalResults = 0
		gridModel.clear()
		if (siteInput.currentText == 'YouTube') searchYouTube();
		else if (siteInput.currentText == 'Dailymotion') searchDailymotion('page', 1);
		else if (siteInput.currentText == 'Vimeo') searchVimeo(1);
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
	    Text {
	      text: "Search options"
	      font.pixelSize: 30
	      font.bold: true
	      color: "#999999"
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
	  // Options: Open
	  Rectangle {
	    width: 600
	    height: 50
	    color: "#F1F1F1"
	    anchors.left: parent.left
	    Text {
	      text: "Open options"
	      font.pixelSize: 30
	      font.bold: true
	      color: "#999999"
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
	    Text {
	      text: "About"
	      font.pixelSize: 30
	      font.bold: true
	      color: "#999999"
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
		  text: "<a href=\"http://sebaro.pro/lightube\" style=\"text-decoration:none;color:#336699;font-size:14px;\">http://sebaro.pro/lightube</a>"
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
		  text: "<a href=\"https://gitlab/sebaro/lightube\" style=\"text-decoration:none;color:#336699;font-size:14px;\">https://gitlab/sebaro/lightube</a>"
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
	cellHeight: 280
	anchors.fill: parent
	model: ListModel {
	  id: gridModel
	}
	delegate:
	  Column {
	    spacing: 10
	    padding: 10
	    Image {
	      source: image
	      state: video
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      height: ((mainLayout.width/Math.floor(mainLayout.width/250) - 20)*9)/16
	      sourceSize.width: 640
	      sourceSize.height: 360
	      MouseArea {
		cursorShape: Qt.PointingHandCursor
		anchors.fill: parent
		onClicked: {
		  var vid = parent.state;
		  var app = applicationInput.text
		  var args = argumentsInput.text.split(' ')
		  args.push(vid)
		  process.start(app, args);
		}
	      }
	    }
	    Text {
	      text: title
	      elide: Text.ElideRight
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      maximumLineCount: 2
	      wrapMode: Text.WordWrap
	      font.bold: true
	      color: "#555555"
	    }
	    Text {
	      text: channel
	      elide: Text.ElideRight
	      width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
	      maximumLineCount: 1
	      wrapMode: Text.WordWrap
	      color: "#777777"
	    }
	  }
      }
    }

    // YouTube
    function searchYouTube(pageToken) {
      var xhrequest = new XMLHttpRequest();
      var url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyCM5q-5xi_0La_TWRViSpV8v0nwgrIS7Ro&maxResults=20';
      if (searchInput.text) url += '&q=' + searchInput.text;
      else return;
      if (pageToken) url += '&pageToken=' + pageToken;
      xhrequest.open('GET', url, true);
      xhrequest.onreadystatechange = function() {
	if (xhrequest.readyState === XMLHttpRequest.DONE) {
	  if (xhrequest.status && xhrequest.status === 200) {
	    var result = JSON.parse(xhrequest.responseText);
	    for (var i = 0; i < result.items.length; i++) {
	      gridModel.append({
		"image": result.items[i].snippet.thumbnails.medium.url,
		"video": "https://www.youtube.com/watch?v=" + result.items[i].id.videoId,
		"title": result.items[i].snippet.title,
		"channel": result.items[i].snippet.channelTitle
	      });
	      totalResults++;
	      if (totalResults == resultsInput.text) break;
	    }
	    if (totalResults < result.pageInfo.totalResults && totalResults < resultsInput.text) {
	      searchYouTube(result.nextPageToken);
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
    function searchDailymotion(type, value) {
      var xhrequest = new XMLHttpRequest();
      var url;
      if (type == 'page') {
	url = 'https://api.dailymotion.com/videos?limit=20';
	if (searchInput.text) url += '&search=' + searchInput.text;
	else return;
	url += '&page=' + value;
      }
      else {
	url = 'https://api.dailymotion.com/video/' + value + '?fields=title,thumbnail_480_url,owner.screenname';
      }
      xhrequest.open('GET', url, true);
      xhrequest.onreadystatechange = function() {
	if (xhrequest.readyState === XMLHttpRequest.DONE) {
	  if (xhrequest.status && xhrequest.status === 200) {
	    var result = JSON.parse(xhrequest.responseText);
	    if (type == 'page') {
	      for (var i = 0; i < result.list.length; i++) {
		searchDailymotion('video', result.list[i].id);
		totalResults++;
		if (totalResults == resultsInput.text) break;
	      }
	      if (totalResults < result.total && totalResults < resultsInput.text) {
		value++
		searchDailymotion('page', value);
	      }
	    }
	    else {
	      gridModel.append({
		"image": result.thumbnail_480_url,
		"video": "https://www.dailymotion.com/video/" + value,
		"title": result.title,
		"channel": result['owner.screenname']
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
    function searchVimeo(page, token) {
      var xhrequest = new XMLHttpRequest();
      var url;
      if (token) {
	url = 'https://api.vimeo.com/search?filter_type=clip&fields=search_web&per_page=20&sizes=640x360';
	if (searchInput.text) url += '&query=' + searchInput.text;
	else return;
	url += '&page=' + page;
	xhrequest.open('GET', url, true);
	xhrequest.setRequestHeader('authorization', 'jwt ' + token);
      }
      else {
	url = "https://vimeo.com/search?q=music";
	request.send(url, {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.75 Safari/537.36'});
	request.response.connect(function(result) {
	  var tokenMatch = result.match(/"jwt":"(.*?)"/);
	  token = (tokenMatch) ? tokenMatch[1] : null;
	  if (token) searchVimeo(1, token);
	  else return;
	});
	return;
      }
      xhrequest.onreadystatechange = function() {
	if (xhrequest.readyState === XMLHttpRequest.DONE) {
	  if (xhrequest.status && xhrequest.status === 200) {
	    var result = JSON.parse(xhrequest.responseText);
	    for (var i = 0; i < result.data.length; i++) {
	      gridModel.append({
		"image": result.data[i].clip.pictures.sizes[0].link,
		"video": result.data[i].clip.link,
		"title": result.data[i].clip.name,
		"channel": result.data[i].clip.user.name
	      });
	      totalResults++;
	      if (totalResults == resultsInput.text) break;
	    }
	    if (totalResults < result.total && totalResults < resultsInput.text) {
	      page++;
	      searchVimeo(page, token);
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
      applicationInput.text = settings.application
      argumentsInput.text = settings.arguments
    }

    Component.onDestruction: {
      settings.windowWidth = mainLayout.width
      settings.windowHeight = mainLayout.height
      settings.searchSite = siteInput.currentText
      settings.searchResults = resultsInput.text
      settings.application = applicationInput.text
      settings.arguments = argumentsInput.text
    }

}
