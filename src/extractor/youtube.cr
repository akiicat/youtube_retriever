require "./info_extractor"

class Youtube
  property video_id : String

  include InfoExtractor

  def initialize(url : String)
    @video_id = extract_id(url)
  end

  def self.dump_json(url : String)
    new(url).real_extract
  end

  def real_extract
    channel_steps = Channel(String).new
    channel_info  = Channel(Hash(String, JSON::Type)).new

    spawn do
      LOG.info "Downloading video webpage: #{@video_id}"
      url           = "https://www.youtube.com/watch?v=#{@video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
      video_webpage = download_webpage(url)
      player_url    = extract_player_url(video_webpage)

      steps = Cache.load(player_url)
      if steps.empty?
        steps = Interpreter.decode_steps(player_url)
        Cache.store(player_url, steps)
      end
      channel_steps.send(steps)
    end

    spawn do
      LOG.info "Downloading video info: #{@video_id}"
      video_info = get_video_info(@video_id)
      channel_info.send(video_info)
    end

    video_info = channel_info.receive
    decipher   = Decipherer.new(steps: channel_steps.receive)

    rtn = {
      :title         => video_info["title"]?.to_s,
      :author        => video_info["author"]?.to_s,
      :thumbnail_url => video_info["thumbnail_url"]?.to_s),
      :streams       => decipher.package(video_info["url_encoded_fmt_stream_map"]?.to_s) + decipher.package(video_info["adaptive_fmts"]?.to_s)
    }
  end
end
