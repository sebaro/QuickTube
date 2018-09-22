
import QtQuick 2.11
import QtQuick.Window 2.11
import Qt.labs.settings 1.0
import Process 1.0


Window {
    id: mainLayout
    title: "Lightube"
    minimumWidth: 700
    minimumHeight: 400

    // Variables
    property int totalResults: 0
    property string pageToken: ""

    // Settings
    Settings {
      id: settings
      property int windowWidth: 700
      property int windowHeight: 400
      property int searchResults: 25
      property string application: "mpv"
      property string arguments: "--ytdl=yes --fs"
    }

    // Process
    Process {
      id: process
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
		pageToken = ""
		gridModel.clear()
		searchYouTube();
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
		TextInput {
		  id: siteInput
		  text: "YouTube"
		  padding: 10
		  anchors.fill: parent
		  selectByMouse: true
		  clip: true
		  readOnly: true
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
	      sourceSize.width: mainLayout.width/Math.floor(mainLayout.width/250) - 20
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


    function searchYouTube() {
      var request = new XMLHttpRequest();
      var url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyDUDqcJzKIA2ZHZ7CpqoOweSc3drGawU1M&maxResults=20';
      if (searchInput.text) url += '&q=' + searchInput.text;
      if (pageToken) url += '&pageToken=' + pageToken;
      request.open('GET', url, true);
      //request.open('GET', '../test/searches.json', true);
      request.onreadystatechange = function() {
	if (request.readyState === XMLHttpRequest.DONE) {
	  if (request.status && request.status === 200) {
	    var result = JSON.parse(request.responseText);
	    pageToken = result.nextPageToken;
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
	      searchYouTube();
	    }
	  }
	  else {
	    console.log("HTTP:", request.status, request.statusText);
	  }
	}
      }
      request.send();
    }

    Component.onCompleted: {
      mainLayout.width = settings.windowWidth
      mainLayout.height = settings.windowHeight
      resultsInput.text = settings.searchResults
      applicationInput.text = settings.application
      argumentsInput.text = settings.arguments
    }

    Component.onDestruction: {
      settings.windowWidth = mainLayout.width
      settings.windowHeight = mainLayout.height
      settings.searchResults = resultsInput.text
      settings.application = applicationInput.text
      settings.arguments = argumentsInput.text
    }

}
