module Youtube
  class Retriever
    property url : String
    property video_id : String
    getter video_info : VideoInfo
    getter decipher : Decipherer
    getter streams : Array(Hash(Symbol, String))

    def initialize(url : String)
      @url = url
      @video_id = ""
      @video_info = VideoInfo.allocate
      @decipher = Decipherer.allocate
      @streams = Array(Hash(Symbol, String)).new

      real_extract
    end

    def self.dump_json(url : String)
      retriever = new(url)
      video_info = retriever.video_info
      {
        :title          => video_info.title,
        :author         => video_info.author,
        :thumbnail_url  => video_info.thumbnail_url,
        :length_seconds => video_info.length_seconds,
        :streams        => retriever.streams
      }
    end

    def self.video_info(url : String)
      retriever = new(url)
      video_info = retriever.video_info
      {
        :title          => video_info.title,
        :author         => video_info.author,
        :thumbnail_url  => video_info.thumbnail_url,
        :length_seconds => video_info.length_seconds,
      }
    end

    def self.get_video_urls(url : String)
      new(url)
          .streams
          .select { |x| x[:comment] == "default" }
          .sort { |a, b| b[:video_resolution].to_i(strict: false) <=> a[:video_resolution].to_i(strict: false) }
    end

    def self.get_audio_urls(url : String)
      new(url)
          .streams
          .select { |x| x[:comment] == "audio only" }
          .sort { |a, b| b[:audio_bitrate].to_i(strict: false) <=> a[:audio_bitrate].to_i(strict: false) }
    end

    private def real_extract
      LOG.info "Downloading video webpage: #{@video_id}"
      embed = Webpage.new("https://www.youtube.com/embed/#{@video_id}")

      @video_id = extract_id
      @video_info = VideoInfo.new(@video_id, embed.extract_sts)
      @decipher = Decipherer.new(embed.extract_player_url)
      @streams = @decipher.package([@video_info.url_encoded_fmt_stream_map, @video_info.adaptive_fmts].join(","))
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
