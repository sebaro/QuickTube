/*
 *
 * Results Widget
 *
 */

import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle {
	property alias gridModel: gridModel
	visible: false
	width: mainWidget.width
	height: mainWidget.height - searchWidget.height
	anchors.top: searchWidget.bottom
	GridView {
		cellWidth: mainWidget.width/Math.floor(mainWidget.width/250)
		cellHeight: ((mainWidget.width/Math.floor(mainWidget.width/250))*9)/16 + 80
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
					width: mainWidget.width/Math.floor(mainWidget.width/250) - 20
					height: ((mainWidget.width/Math.floor(mainWidget.width/250) - 20)*9)/16
					sourceSize.width: 640
					sourceSize.height: 360
					MouseArea {
						cursorShape: Qt.PointingHandCursor
						anchors.fill: parent
						onClicked: {
							open(videoLink);
						}
					}
				}
				Text {
					text: videoTitle
					elide: Text.ElideRight
					clip: true
					width: mainWidget.width/Math.floor(mainWidget.width/250) - 20
					maximumLineCount: 2
					wrapMode: Text.WordWrap
					font.bold: true
					color: "#555555"
					MouseArea {
						id: titleMouseArea
						cursorShape: Qt.PointingHandCursor
						anchors.fill: parent
						hoverEnabled: true
						onClicked: {
							open(videoLink);
						}
						onEntered: {
							parent.color = "#000000"
						}
						onExited: {
							parent.color = "#555555"
						}
					}
					ToolTip {
						text: videoTitle
						visible: titleMouseArea.containsMouse
						delay: 0
					}
				}
				Text {
					text: channelTitle
					elide: Text.ElideRight
					clip: true
					width: mainWidget.width/Math.floor(mainWidget.width/250) - 20
					maximumLineCount: 1
					wrapMode: Text.WordWrap
					color: "#777777"
					MouseArea {
						cursorShape: Qt.PointingHandCursor
						anchors.fill: parent
						hoverEnabled: true
						onClicked: {
							search(channelID);
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
