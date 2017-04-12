require "kemal"
require "json"
require "./extractor/*"

before_get "/" do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

get "/" do |env|
  Youtube._real_extract("iDfZua4IS4A").to_json
  # Youtube._real_extract("iDfZua4IS4A")["args"]["title"]
end


Kemal.run
