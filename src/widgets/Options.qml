/*
 *
 * Options Widget
 *
 */

import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle {
  property alias siteInput: siteInput
  property alias resultsInput: resultsInput
  property alias safeInput: safeInput
  property alias sortInput: sortInput
  property alias channelInput: channelInput
  property alias videoInput: videoInput
  property alias applicationInput: applicationInput
  color: "#F1F1F1"
  width: mainWidget.width
  height: mainWidget.height - searchWidget.height
  anchors.top: searchWidget.bottom
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
	  text: "Search"
	  font.pixelSize: 18
	  font.bold: true
	  color: "#777777"
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
	      verticalAlignment: TextInput.AlignVCenter
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
      // Separator
      Rectangle {
	width: 600
	height: 50
	color: "#F1F1F1"
	Rectangle {
	  width: 600
	  height: 1
	  color: "#E9E9E9"
	  anchors.verticalCenter: parent.verticalCenter
	}
      }
      // Options: Open
      Rectangle {
	width: 600
	height: 50
	color: "#F1F1F1"
	anchors.left: parent.left
	Text {
	  text: "Open"
	  font.pixelSize: 18
	  font.bold: true
	  color: "#777777"
	  verticalAlignment: Text.AlignVCenter
	  anchors.fill: parent
	  leftPadding: 15
	}
      }
      // Options: Video
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
	      text: "Video"
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
	      id: videoInput
	      model: ["Link", "Stream"]
	      anchors.fill: parent
	    }
	  }
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
	      verticalAlignment: TextInput.AlignVCenter
	    }
	  }
	}
      }
      // Separator
      Rectangle {
	width: 600
	height: 50
	color: "#F1F1F1"
	Rectangle {
	  width: 600
	  height: 1
	  color: "#E9E9E9"
	  anchors.verticalCenter: parent.verticalCenter
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
	  font.pixelSize: 18
	  font.bold: true
	  color: "#777777"
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
	      verticalAlignment: TextInput.AlignVCenter
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
	      text: "<a href=\"http://sebaro.pro/quicktube\" style=\"text-decoration:none;color:#0AAFC3;font-size:12px;\">http://sebaro.pro/quicktube</a>"
	      padding: 10
	      anchors.fill: parent
	      clip: true
	      textFormat: Text.RichText
	      onLinkActivated: Qt.openUrlExternally(link)
	      verticalAlignment: TextInput.AlignVCenter
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
	      text: "<a href=\"https://gitlab.com/sebaro/quicktube\" style=\"text-decoration:none;color:#0AAFC3;font-size:12px;\">https://gitlab.com/sebaro/quicktube</a>"
	      padding: 10
	      anchors.fill: parent
	      clip: true
	      textFormat: Text.RichText
	      onLinkActivated: Qt.openUrlExternally(link)
	      verticalAlignment: TextInput.AlignVCenter
	      MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.NoButton
		cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
	      }
	    }
	  }
	}
      }
      // Spacer
      Rectangle {
	width: 600
	height: 50
	color: "#F1F1F1"
      }
    }
  }
}
