require "json"
require "logger"
require "http/client"
require "./helpers/*"
require "./extractor/interpreter"
require "./extractor/decipherer"
require "./extractor/info_extractor"
require "./extractor/youtube"

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO
