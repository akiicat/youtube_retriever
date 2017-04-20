require "kemal"
require "./config"

before_get "/" do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

get "/" do |env|
  Youtube.dump_json("iDfZua4IS4A").to_json
end

get "/python" do |env|
  io = IO::Memory.new
  Process.run("youtube-dl", ["-j", "iDfZua4IS4A"], output: io)
  JSON.parse(io.to_s).to_json
end


Kemal.run
