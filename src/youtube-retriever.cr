require "json"
require "logger"
require "http/client"
require "./youtube-retriever/helpers/*"

# module
require "./youtube-retriever/extractor/cache"
require "./youtube-retriever/extractor/codecs"
require "./youtube-retriever/extractor/interpreter"
require "./youtube-retriever/extractor/info_extractor"

# class
require "./youtube-retriever/extractor/decipherer"
require "./youtube-retriever/extractor/youtube"

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO

module YoutubeRetriever
end
