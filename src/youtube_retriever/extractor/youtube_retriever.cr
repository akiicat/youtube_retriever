require "./webpage"

module Youtube
  class Retriever
    property video_id : String

    def initialize(url : String)
      @url = url
      @video_id = extract_id
    end

    def self.dump_json(url : String)
      new(url).real_extract
    end

    def real_extract
      LOG.info "Downloading video webpage: #{@video_id}"
      embed = Webpage.new("https://www.youtube.com/embed/#{@video_id}")

      video_info = get_video_info(@video_id, embed.extract_sts)
      decipher = Decipherer.new(embed.extract_player_url)

      rtn = {
        :title          => video_info["title"]?.to_s,
        :author         => video_info["author"]?.to_s,
        :thumbnail_url  => video_info["thumbnail_url"]?.to_s,
        :length_seconds => video_info["length_seconds"]?.to_s,
        :streams        => decipher.package(video_info["url_encoded_fmt_stream_map"]?.to_s) + decipher.package(video_info["adaptive_fmts"]?.to_s)
      }
    end

    private def extract_id
      LOG.info "[EXTRACT] extract id"
      valid_url = /^((?:https?:\/\/|\/\/)(?:(?:(?:(?:www\.)?youtube\.com\/)(?:(?:(?:v|embed|e)\/(?!videoseries))|(?:(?:(?:watch|movie)\/?)?(?:\?)v=)))|(?:youtu\.be)\/))?(?<video_id>[0-9A-Za-z_-]{11})/
      video_id = @url.match(valid_url).try(&.["video_id"]).to_s
      raise "Invalid URL: #{@url}" if video_id.empty?
      video_id
    end

    private def get_video_info(video_id : String, sts : String = "", proto : String = "https")
      LOG.info "[Download] video info: #{video_id} #{sts}"
      video_info = Hash(String, JSON::Type).new
      el_types   = ["&el=embedded", "&el=detailpage", "&el=vevo", "&el=info", ""]
      el_types.each do |el_type|
        eurl          = ENV["EURL"]? || "https://www.google.com"
        video_url     = "#{proto}://www.youtube.com/get_video_info?&video_id=#{video_id}#{el_type}&ps=default&gl=US&hl=en&sts=#{sts}&eurl=#{eurl}"
        video_webpage = Webpage.new(video_url).content
        video_info    = JSON.parse(URI.decode_www_form(video_webpage).to_json).as_h

        break if video_info.has_key?("token")
      end
      video_info
    end
  end

  class Handler
    def initialize(url : String)
      @video_id = extract_id(url)
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
        video_webpage = download_webpage(video_url)
        video_info    = JSON.parse(URI.decode_www_form(video_webpage).to_json).as_h

        break if video_info.has_key?("token")
      end
      video_info
    end


    def self.dump_json(url : String)
      Retriever.real_extract(video_id)
    end

    def self.video_only(url : String)
    end

    def self.audio_only(url : String)
    end

    def self.defualt_video(url : String)
    end

    def self.info(url : String)
    end
  end
end
