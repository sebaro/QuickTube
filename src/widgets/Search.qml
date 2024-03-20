/*
 *
 * Search Widget
 *
 */

import QtQuick 2.15


Rectangle {
	property alias searchInput: searchInput
	color: "#F1F1F1"
	width: mainWidget.width
	height: 100
	z: 1
	Row {
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		// Logo
		Rectangle {
			color: "#FFFFFF"
			border.width: 1
			border.color: "#E1E1E1"
			width: 120
			height: 40
			Image {
				source: "qrc:/images/logo.png"
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}
		// Search Input
		Rectangle {
			color: "#FFFFFF"
			border.width: 1
			border.color: "#E1E1E1"
			width: Math.floor(mainWidget.width * 70 / 100)
			height: 40
			TextInput {
				id: searchInput
				text: "funny cats"
				padding: 10
				anchors.fill: parent
				selectByMouse: true
				focus: true
				verticalAlignment: TextInput.AlignVCenter
				onAccepted: {
					searchWidget.height = 100
					optionsButton.visible = true
					if (!resultsWidget.visible) {
						optionsWidget.visible = false
						resultsWidget.visible = true
						optionsImage.source = "qrc:/images/down.png"
					}
					search()
				}
			}
		}
		// Search Button
		Rectangle {
			color: "#FFFFFF"
			border.width: 1
			border.color: "#E1E1E1"
			width: 40
			height: 40
			Image {
				source: "qrc:/images/search.png"
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				MouseArea {
					cursorShape: Qt.PointingHandCursor
					anchors.fill: parent
					onClicked: {
						searchWidget.height = 100
						optionsButton.visible = true
						if (!resultsWidget.visible) {
							optionsWidget.visible = false
							resultsWidget.visible = true
							optionsImage.source = "qrc:/images/down.png"
						}
						search()
					}
				}
				Keys.onPressed: {
					if (event.key == Qt.Key_Enter) {
						searchWidget.height = 100
						optionsButton.visible = true
						if (!resultsWidget.visible) {
							optionsWidget.visible = false
							resultsWidget.visible = true
							optionsImage.source = "qrc:/images/down.png"
						}
						search()
					}
				}
			}
		}
		// Option Button
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
				source: "qrc:/images/down.png"
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				MouseArea {
					cursorShape: Qt.PointingHandCursor
					anchors.fill: parent
					onClicked: {
						if (parent.source.toString().indexOf("qrc:/images/down.png") != -1) {
							parent.source = "qrc:/images/up.png"
							optionsWidget.visible = true
							resultsWidget.visible = false
						}
						else {
							parent.source = "qrc:/images/down.png"
							optionsWidget.visible = false
							resultsWidget.visible = true
						}
					}
				}
			}
		}
	}
}
