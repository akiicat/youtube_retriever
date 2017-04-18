require "json"
require "logger"
require "http/client"
require "./helpers/*"
require "./extractor/*"

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO
