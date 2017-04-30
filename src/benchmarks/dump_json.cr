require "benchmark"
require "../youtube_retriever"

LOG.level = Logger::ERROR

Benchmark.ips do |x|
  x.report("non cipher") { YoutubeRetriever.dump_json("iDfZua4IS4A") }
  x.report("vevo") { YoutubeRetriever.dump_json("6YpYgT2B6Hg") }
  x.report("age gate") { YoutubeRetriever.dump_json("Ci6lMQNLKZU") }
  x.report("viewer under 300") { YoutubeRetriever.dump_json("esGPFvKCkOY") }
end
