module Youtube
  class Retriever
    property video_id : String

    def initialize(url : String)
      @url = url
      @video_id = extract_id
      @video_info = VideoInfo.allocate
      @decipher = Decipherer.allocate
    end

    def self.dump_json(url : String)
      new(url).real_extract
    end

    def self.video_only(url : String)
    end

    def self.audio_only(url : String)
    end

    def self.defualt_video(url : String)
    end

    def self.info(url : String)
    end

    def real_extract
      LOG.info "Downloading video webpage: #{@video_id}"
      embed = Webpage.new("https://www.youtube.com/embed/#{@video_id}")

      @video_info = VideoInfo.new(@video_id, embed.extract_sts)
      @decipher = Decipherer.new(embed.extract_player_url)

      decoded_streams = [@video_info.url_encoded_fmt_stream_map, @video_info.adaptive_fmts].join(",")
      rtn = {
        :title          => @video_info.title,
        :author         => @video_info.author,
        :thumbnail_url  => @video_info.thumbnail_url,
        :length_seconds => @video_info.length_seconds,
        :streams        => @decipher.package(decoded_streams)
      }
    end

    private def extract_id
      LOG.info "[EXTRACT] extract id"
      valid_url = /^((?:https?:\/\/|\/\/)(?:(?:(?:(?:www\.)?youtube\.com\/)(?:(?:(?:v|embed|e)\/(?!videoseries))|(?:(?:(?:watch|movie)\/?)?(?:\?)v=)))|(?:youtu\.be)\/))?(?<video_id>[0-9A-Za-z_-]{11})/
      video_id = @url.match(valid_url).try(&.["video_id"]).to_s
      raise "Invalid URL: #{@url}" if video_id.empty?
      video_id
    end
  end
end
