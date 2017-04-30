module InfoExtractor
  extend self

  def download_webpage(url, tries = 1, timeout = 5)
    response = ""
    loop do
      begin
        LOG.info "[DOWNLOAD] webpage: #{url}"
        response = HTTP::Client.get(url).body
        break
      rescue e
        raise e if (tries -= 1) <= 0
        LOG.info "[DOWNLOAD] Waiting for #{timeout}s seconds: #{url}"
        sleep(timeout)
      end
    end
    response
  end

  def extract_id(url)
    LOG.info "[EXTRACT] extract id"
    valid_url = /^((?:https?:\/\/|\/\/)(?:(?:(?:(?:www\.)?youtube\.com\/)(?:(?:(?:v|embed|e)\/(?!videoseries))|(?:(?:(?:watch|movie)\/?)?(?:\?)v=)))|(?:youtu\.be)\/))?(?<video_id>[0-9A-Za-z_-]{11})/
    video_id = url.match(valid_url).try(&.["video_id"]).to_s
    raise "Invalid URL: #{url}" if video_id.empty?
    video_id
  end

  def get_video_info(video_id : String, sts : String = "", proto : String = "https")
    LOG.info "[Download] video info: #{video_id} #{sts}"
    video_info = Hash(String, JSON::Type).new
    el_types   = ["&el=embedded", "&el=detailpage", "&el=vevo", "&el=info", ""]
    el_types.each do |el_type|
      eurl          = ENV["EURL"]? || "https://www.google.com"
      video_url     = "#{proto}://www.youtube.com/get_video_info?&video_id=#{video_id}#{el_type}&ps=default&gl=US&hl=en&sts=#{sts}&eurl=#{eurl}"
      video_webpage = InfoExtractor.download_webpage(video_url)
      video_info    = JSON.parse(URI.decode_www_form(video_webpage).to_json).as_h

      break if video_info.has_key?("token")
    end
    video_info
  end

  def extract_player_url(video_webpage)
    begin
      LOG.info "[EXTRACT] player url"
      assets_re  = /"assets":.+?"js":\s*(?<url>"[^"]+")/
      player_url = video_webpage.match(assets_re).try(&.["url"]).to_s.as_json

      case player_url
        when /^\/\//				then "https:#{player_url}"
        when /^https?:\/\// then player_url
        else "https://www.youtube.com#{player_url}"
      end
    rescue
      raise "can't find player url"
    end
  end

  def extract_sts(video_webpage)
    begin
      LOG.info "[EXTRACT] sts"
      sts_re = /"sts":(?<sts>\d+),/
      video_webpage.match(/"sts":(?<sts>\d+),/).try(&.["sts"]).to_s
    rescue
      raise "can't find sts"
    end
  end
end
