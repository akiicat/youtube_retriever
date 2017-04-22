require "kemal"
require "./config"

ERROR = { status: "fail" }

get "/" do |env|
  env.response.content_type = "application/json; charset=utf-8"
  Youtube.dump_json("iDfZua4IS4A").to_json
end

get "/python" do |env|
  env.response.content_type = "application/json; charset=utf-8"
  io = IO::Memory.new
  Process.run("youtube-dl", ["-j", "iDfZua4IS4A"], output: io)
  JSON.parse(io.to_s).to_json
end

get "/vevo" do |env|
  env.response.content_type = "application/json; charset=utf-8"
  Youtube.dump_json("tvTRZJ-4EyI").to_json
end

get "/head" do |env|
  env.response.content_type = "application/json; charset=utf-8"
  a = "https://r8---sn-ipoxu-un5d.googlevideo.com/videoplayback?key=yt6&ip=61.220.182.115&mn=sn-ipoxu-un5d&mm=31&ms=au&ipbits=0&pl=24&mv=m&mt=1492746088&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&requiressl=yes&ei=wn_5WIj6MMbC4QLPjqfgCg&dur=183.646&mime=video%2Fmp4&itag=22&expire=1492767778&upn=lAO3p86liWI&lmt=1490906644132788&ratebypass=yes&id=o-APHph8qjXg5M1HpyIgVYcmI8BR2Xuwueo6brxDRqZrCw&initcwndbps=3042500&source=youtube&signature=54F2D56F999AE929356D8EC615A3CB404AFDEA13.CEF23004A5BE049913276FD3D6B60C548782B0BD"

  HTTP::Client.head(a).status_code
end

get "/error" do |env|
  env.response.content_type = "application/json; charset=utf-8"
  begin
    Youtube.dump_json("iDfZua4IsS4A").to_json
  rescue
    ERROR.to_json
  end
end

Kemal.run
