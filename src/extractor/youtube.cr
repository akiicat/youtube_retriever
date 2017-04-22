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
    @video_webpage     = InfoExtractor.download_webpage(url)
    @player_url        = InfoExtractor.extract_player_url(@video_webpage)
    @decipher          = Decipherer.new(@player_url)

    LOG.info "Downloading video info: #{@video_id}"
    @video_info        = InfoExtractor.get_video_info(@video_id)
    @video_title       = @video_info["title"]?.to_s
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

      # 1705 	                if type_:
      # 1706 	                    type_split = type_.split(';')
      # 1707 	                    kind_ext = type_split[0].split('/')
      # 1708 ->	                    if len(kind_ext) == 2:
      # 1709 	                        kind, _ = kind_ext
      # 1710 	                        dct['ext'] = mimetype2ext(type_split[0])
      # 1711 	                        if kind in ('audio', 'video'):
      # 1712 	                            codecs = None
      # 1713 	                            for mobj in re.finditer(
      # 1714 	                                    r'(?P<key>[a-zA-Z_-]+)=(?P<quote>["\']?)(?P<val>.+?)(?P=quote)(?:;|$)', type_):
      # 1715 ->	                                if mobj.group('key') == 'codecs':
      # 1716 	                                    codecs = mobj.group('val')
      # 1717 	                                    break
      # 1718 	                            if codecs:
      # 1719 	                                dct.update(parse_codecs(codecs))
      # 1720 	                formats.append(dct)
      # {u'vcodec': u'avc1.64001F', u'acodec': u'mp4a.40.2'}

      url_data["url"] = url

      @encoded_url_map.push url_data
    end
  end
end
