require "json"
require "logger"
require "http/client"
require "./helpers/*"

# module
require "./extractor/cache"
require "./extractor/codecs"
require "./extractor/interpreter"
require "./extractor/info_extractor"

# class
require "./extractor/decipherer"
require "./extractor/youtube"

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO
