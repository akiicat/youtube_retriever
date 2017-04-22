require "./info_extractor"

class Youtube
  property video_id = ""
  property video_info = Hash(String, JSON::Type).new
  property video_webpage = ""
  property embed_webpage = ""
  property video_title = ""
  property video_description = ""
  property proto = "https"
  property player_url = ""
  property encoded_url_map = [] of Hash(String, String)
  property decipher = Decipherer.allocate

  include InfoExtractor

  def initialize(url : String)
    @video_id = extract_id(url)
  end

  def self.dump_json(url : String)
    a = new(url)
    a.real_extract
    a.encoded_url_map
  end

  # url = "https://www.youtube.com/watch?v=iDfZua4IS4A"
  def real_extract
    LOG.info "Downloading video webpage: #{@video_id}"
    url = "#{@proto}://www.youtube.com/watch?v=#{@video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
    @video_webpage     = download_webpage(url)
    @player_url        = extract_player_url(@video_webpage)
    @decipher          = Decipherer.new(@player_url)

    LOG.info "Downloading video info: #{@video_id}"
    @video_info        = get_video_info(@video_id)
    @video_title       = video_info["title"]?.to_s
    @video_description = video_info["eow-description"]?.to_s

    encoded_url_map  = @video_info["url_encoded_fmt_stream_map"]?.to_s.split(",")
    encoded_url_map += @video_info["adaptive_fmts"]?.to_s.split(",")
    encoded_url_map.each do |url_data_str|
			url_data_str
      url_data = URI.decode_www_form(url_data_str)
      next if !url_data.has_key? "itag" || !url_data.has_key? "url"
      url = url_data["url"]

      if url_data.has_key? "sig"
        url += "&signature=" + url_data["sig"]
      elsif url_data.has_key? "s"
        url += "&signature=" + @decipher.decrypt(url_data["s"]).to_s
      end
      if /ratebypass/ !~ url
        url += "&ratebypass=yes"
      end


      url_data["url"] = url

      @encoded_url_map.push url_data
    end
  end
end
