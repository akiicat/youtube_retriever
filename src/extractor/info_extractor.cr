require "../config"

class InfoExtractor
  def self.download_webpage(url, tries = 1, timeout = 5)
    response = ""
    loop do
      begin
        LOG.info "Downloading webpage: #{url}"
        response = HTTP::Client.get(url).body
        break
      rescue e
        raise e if (tries -= 1) <= 0
        LOG.info "Waiting for #{timeout}s seconds: #{url}"
        sleep(timeout)
      end
    end
    response
  end

  def self.extract_id(url)
    valid_url = /^((?:https?:\/\/|\/\/)(?:(?:(?:(?:www\.)?youtube\.com\/)(?:(?:(?:v|embed|e)\/(?!videoseries))|(?:(?:(?:watch|movie)\/?)?(?:\?)v=)))|(?:youtu\.be)\/))?(?<video_id>[0-9A-Za-z_-]{11})/
    video_id  = url.match(valid_url).try(&.["video_id"]).to_s
    raise "Invalid URL: #{url}" if video_id.empty?
    video_id
  end

  def self.get_video_info(video_id : String, proto : String = "https")
    video_info = Hash(String, JSON::Type).new
    el_types   = ["&el=embedded", "&el=detailpage", "&el=vevo", "&el=info", ""]
    el_types.each do |el_type|
      # 'https://www.youtube.com/get_video_info?video_id='+video_id+'&eurl=https://youtube.googleapis.com/v/'+video_id+'&sts='+sts
      video_url     = "#{proto}://www.youtube.com/get_video_info?&video_id=#{video_id}#{el_type}&ps=default&eurl=&gl=US&hl=en"
      # video_url     = "#{proto}://www.youtube.com/get_video_info?&video_id=#{video_id}#{el_type}&ps=default&gl=US&hl=en&eurl=https://youtube.googleapis.com/v/#{video_id}&sts="
      video_webpage = InfoExtractor.download_webpage(video_url)
      video_info    = JSON.parse(URI.decode_www_form(video_webpage).to_json).as_h

      break if video_info.has_key?("token")
    end
    video_info
  end

  def self.extract_player_url(video_webpage)
    assets_re  = /"assets":.+?"js":\s*(?<url>"[^"]+")/
    player_url = video_webpage.match(assets_re).try(&.["url"]).to_s.as_json

    raise "can't find player url" if player_url.empty?

    case player_url
      when /^\/\//				then "https:#{player_url}"
      when /^https?:\/\// then player_url
      else "https://www.youtube.com#{player_url}"
    end
  end
end
