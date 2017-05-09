module Youtube
  class VideoInfo
    getter sts : String
    getter video_id : String
    getter eurl : String
    getter content : Hash(String, JSON::Type)

    def initialize(video_id : String, sts : String = "")
      @sts = ""
      @video_id = video_id

      @eurl = ENV["EURL"]? || "https://www.google.com"
      @types = ["&el=embedded", "&el=detailpage", "&el=vevo", "&el=info", ""]

      @content = Hash(String, JSON::Type).new
      get_video_info
    end

    def get_video_info
      LOG.info "[Download] video info: #{@video_id} #{@sts}"
      @types.each do |type|
        video_url   = "https://www.youtube.com/get_video_info?&video_id=#{@video_id}#{type}&ps=default&gl=US&hl=en&sts=#{@sts}&eurl=#{@eurl}"
        @content = Webpage.new(video_url).extract_video_info

        break if @content.has_key?("token")
      end
    end

    macro expand(name)
      def {{name}}
        @content["{{name}}"]?.to_s
      end
    end

    expand title
    expand author
    expand thumbnail_url
    expand length_seconds
    expand url_encoded_fmt_stream_map
    expand adaptive_fmts
  end
end
