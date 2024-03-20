
QuickTube is a simple tool for searching and opening videos from video sharing web sites.

Each result includes three items: the video thumbnail, the video title and the video owner/channel.
Clicking the thumbnail or the title will open the video with the chosen application.
Clicking the channel will search or list its videos.

![](https://gitlab.com/sebaro/QuickTube/raw/master/screenshot1.png)
![](https://gitlab.com/sebaro/QuickTube/raw/master/screenshot2.png)


# Installation

#### Requirements:
     >=qtgui-5.15
     >=qtcore-5.15
     >=qtnetwork-5.15
     >=qtqml-5.15
     >=qtquick-5.15
     >=qtwidgets-5.15

#### Build & install:
     qmake
     make
     make install


# Options

## Search

#### Site: YouTube | Dailymotion | Vimeo
   - Which site to search.

#### Results: 25
   - The maximum results per search.

#### Safe: No | Yes
   - Whether the search results should include restricted content.

#### Sort: Relevance | Date | Views | Rating | Alphabetical
   - The method that will be used to order results.

#### Channel: No | Yes
   - Whether to search the channel's videos or just list them.

## Open

#### Video: Link | Stream
   - Whether to open the video link or the video stream.

#### Application: mpv --ytdl=yes --fs
   - What application is used to open the video.
