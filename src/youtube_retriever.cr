require "json"
require "logger"
require "http/client"
require "./youtube_retriever/helpers/*"

# module
require "./youtube_retriever/extractor/interpreter"
require "./youtube_retriever/extractor/webpage"

# decipherer
require "./youtube_retriever/extractor/cache"
require "./youtube_retriever/extractor/codecs"
require "./youtube_retriever/extractor/decipherer"

# retriever
require "./youtube_retriever/extractor/video_info"
require "./youtube_retriever/extractor/youtube_retriever"

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO
