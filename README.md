[![Build Status](https://travis-ci.org/akiicat/youtube_retriever.svg?branch=master)](https://travis-ci.org/akiicat/youtube_retriever)

# Youtube Retriever

Extract youtube video info. There is [How it works](https://www.quora.com/How-can-I-make-a-YouTube-video-downloader-web-application-from-scratch)

## Installation

- [Install Crystal](https://crystal-lang.org/docs/installation/)

```yml
dependencies:
  youtube_retriever:
    github: akiicat/youtube_retriever
    branch: master
```

```
crystal deps
```

## Usage

```cr
require "youtube_retriever"

YoutubeRetriever.dump_json("iDfZua4IS4A")
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/akiicat/youtube_retriever/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
