[![Build Status](https://travis-ci.org/akiicat/youtube_retriever.svg?branch=master)](https://travis-ci.org/akiicat/youtube_retriever)

# Youtube Retriever

Extract youtube video info. [How it works](https://www.quora.com/How-can-I-make-a-YouTube-video-downloader-web-application-from-scratch)

## Installation

- [Install Crystal](https://crystal-lang.org/docs/installation/)

```yml
# shard.yml
dependencies:
  youtube_retriever:
    github: akiicat/youtube_retriever
    branch: master
```

Install dependency package

```
crystal deps
```

## Usage

```cr
require "youtube_retriever"

YoutubeRetriever.dump_json("iDfZua4IS4A")
```

Retrieve message

```json
{
  "title": "Hello Nico〈接下來如何〉官方MV",
  "author": "黑市音樂",
  "thumbnail_url": "https://i.ytimg.com/vi/iDfZua4IS4A/default.jpg",
  "length_seconds": "285",
  "streams": [
    {
      "itag": "22",
      "container": "MP4",
      "video_resolution": "720p",
      "video_encoding": "H.264",
      "video_profile": "High",
      "video_bitrate": "42769",
      "audio_encoding": "AAC",
      "audio_bitrate": "192",
      "comment": "default",
      "url": "https://r17---sn-a5m7lnes.googlevideo.com/videoplayback?upn=MwgcZ4Qf6z4&mt=1493538623&mn=sn-a5m7lnes&itag=22&sparams=dur%2Cei%2Cid%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&lmt=1481464250294058&dur=284.839&ratebypass=yes&ip=35.185.235.88&source=youtube&ei=l5cFWbmUK8O0_APA9baIDw&ms=au&requiressl=yes&ipbits=0&pl=20&mv=m&id=o-AETx6aICa6_LueROrL_fQU-4bLsXJJOMvEDqrBiWYWPg&mime=video%2Fmp4&key=yt6&expire=1493560311&mm=31&signature=3F1ED0B8831934D6E14F56F0467CE09005BBFBB5.94A565109A4D33B1B2F5834D60B856A76B968E74"
    }
  ]
}
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/akiicat/youtube_retriever/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
