/*
 *
 * Window Widget
 *
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.0

import Process 1.0
import Request 1.0

import "qrc:/scripts/YouTube.js" as YouTube
import "qrc:/scripts/Dailymotion.js" as Dailymotion
import "qrc:/scripts/Vimeo.js" as Vimeo


Window {
	id: mainWidget
	title: "QuickTube"
	minimumWidth: 750
	minimumHeight: 400

	// Version
	property string version: "2024.03.20"

	// Variables
	property int totalResults: 0

	// Debug
	property bool debug: false

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
		property string video: "Link"
		property string application: "mpv --ytdl=yes --fs"
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
	Search {
		id: searchWidget
	}
	property alias searchInput: searchWidget.searchInput

	// Results
	Results {
		id: resultsWidget
	}
	property alias gridModel: resultsWidget.gridModel

	Options {
		id: optionsWidget
	}
	property alias siteInput: optionsWidget.siteInput
	property alias resultsInput: optionsWidget.resultsInput
	property alias safeInput: optionsWidget.safeInput
	property alias sortInput: optionsWidget.sortInput
	property alias channelInput: optionsWidget.channelInput
	property alias videoInput: optionsWidget.videoInput
	property alias applicationInput: optionsWidget.applicationInput

	function open(url) {
		var app = applicationInput.text.split(' ')[0];
		var args = applicationInput.text.split(' ').slice(1);
		if (videoInput.currentText == 'Stream') {
			if (siteInput.currentText == 'YouTube') {
				YouTube.stream(url, function(data) {
					args.push(data);
					if (debug) console.log('Process: ' + '\n' + app + ' ' + args.join(' ') + '\n');
					process.start(app, args);
				});
			}
			else if (siteInput.currentText == 'Dailymotion') {
				Dailymotion.stream(url, function(data) {
					args.push(data);
					if (debug) console.log('Process: ' + '\n' + app + ' ' + args.join(' ') + '\n');
					process.start(app, args);
				});
			}
			else if (siteInput.currentText == 'Vimeo') {
				Vimeo.stream(url, function(data) {
					args.push(data);
					if (debug) console.log('Process: ' + '\n' + app + ' ' + args.join(' ') + '\n');
					process.start(app, args);
				});
			}
		}
		else {
			args.push(url);
			if (debug) console.log('Process: ' + '\n' + app + ' ' + args.join(' ') + '\n');
			process.start(app, args);
		}
	}

	function search(channel) {
		if (!channel && !searchInput.text) return;
		totalResults = 0;
		gridModel.clear();
		if (siteInput.currentText == 'YouTube') YouTube.search(channel, null);
		else if (siteInput.currentText == 'Dailymotion') Dailymotion.search(channel, 'page', 1);
		else if (siteInput.currentText == 'Vimeo') Vimeo.search(channel, 1, null);
	}

	Component.onCompleted: {
		mainWidget.width = settings.windowWidth
		mainWidget.height = settings.windowHeight
		siteInput.currentIndex = siteInput.model.indexOf(settings.searchSite)
		resultsInput.text = settings.searchResults
		safeInput.currentIndex = safeInput.model.indexOf(settings.searchSafe)
		sortInput.currentIndex = sortInput.model.indexOf(settings.searchSort)
		channelInput.currentIndex = channelInput.model.indexOf(settings.searchChannel)
		videoInput.currentIndex = videoInput.model.indexOf(settings.video)
		applicationInput.text = settings.application
	}

	Component.onDestruction: {
		settings.windowWidth = mainWidget.width
		settings.windowHeight = mainWidget.height
		settings.searchSite = siteInput.currentText
		settings.searchResults = resultsInput.text
		settings.searchSafe = safeInput.currentText
		settings.searchSort = sortInput.currentText
		settings.searchChannel = channelInput.currentText
		settings.video = videoInput.currentText
		settings.application = applicationInput.text
	}

	onClosing: {
		if (debug) console.log("Stopping processes! Closing!" + '\n');
		process.stop();
	}
}
