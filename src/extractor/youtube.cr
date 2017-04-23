require "./info_extractor"

class Youtube
  property video_id : String
  property encoded_url_map = [] of Hash(Symbol, String)
  property adaptive_fmts = [] of Hash(Symbol, String)

  include InfoExtractor

  def initialize(url : String)
    @video_id = extract_id(url)
  end

  def self.dump_json(url : String)
    a = new(url)
    a.real_extract
    a.encoded_url_map + a.adaptive_fmts
  end

  # url = "https://www.youtube.com/watch?v=iDfZua4IS4A"
  def real_extract
    LOG.info "Downloading video webpage: #{@video_id}"
    url           = "https://www.youtube.com/watch?v=#{@video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
    video_webpage = download_webpage(url)
    player_url    = extract_player_url(video_webpage)

    decipher       = Decipherer.new
    decipher.steps = Cache.load(player_url)
    if decipher.steps.empty?
      decipher.url = player_url
      decipher.decode
      Cache.store(player_url, decipher.steps)
    end

    LOG.info "Downloading video info: #{@video_id}"
    video_info        = get_video_info(@video_id)
    video_title       = video_info["title"]?.to_s
    video_description = video_info["eow-description"]?.to_s

    @encoded_url_map  = decipher.package(video_info["url_encoded_fmt_stream_map"]?.to_s)
    @adaptive_fmts    = decipher.package(video_info["adaptive_fmts"]?.to_s)
  end
end
