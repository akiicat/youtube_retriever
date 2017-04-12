require "json"
require "./info_extractor"
require "../helpers/uri_helper"

class Youtube
  VALID_URL = /^((?:https?:\/\/|\/\/)(?:(?:(?:(?:www\.)?youtube\.com\/)(?:(?:(?:v|embed|e)\/(?!videoseries))|(?:(?:(?:watch|movie)\/?)?(?:\?)v=)))|(?:youtu\.be)\/))?(?<video_id>[0-9A-Za-z_-]{11})/

  def initialize()
    @@video_id = ""
    @@video_info = Hash(String, JSON::Type)
  end

  # url = "https://www.youtube.com/watch?v=iDfZua4IS4A"
  # _real_extract(url)
  def self._real_extract(url)
    proto = "https"
    @@video_id = extract_id(url)

    url = "#{proto}://www.youtube.com/watch?v=#{video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
    video_webpage = InfoExtractor.new(@@video_id).download_webpage(url)

    video_info = get_ytplayer_config(video_webpage)

    puts "#{video_id}: Downloading video info webpage"
    ["&el=info", "&el=embedded", "&el=detailpage", "&el=vevo", ""].each do |el_type|
      video_info_url = "#{proto}://www.youtube.com/get_video_info?&video_id=#{video_id}#{el_type}&ps=default&eurl=&gl=US&hl=en"
      video_info_webpage = InfoExtractor.new(@@video_id).download_webpage(video_info_url)
      get_video_info = URI.decode_www_form(video_info_webpage)

      if get_video_info.has_key?("token")
        if !video_info.has_key?("token")
          video_info = get_video_info
          break
        end
      end
    end

    # video_title = video_info["title"]?
    # video_description = video_info["eow-description"]?
    encoded_url_map = "%s,%s" % [video_info["url_encoded_fmt_stream_map"]?, video_info["adaptive_fmts"]?]

    encoded_url_map.split(',').each do |url_data_str|
      url_data = URI.decode_www_form(url_data_str)
      if !url_data.has_key?["itag"] or !url_data.has_key?["url"]
        continue
      end
      format_id = url_data["itag"]
      url = url_data["url"]


      if url_data.has_key?["sig"]
        url += "&signature=" + url_data["sig"]
      elsif url_data.has_key?["s"]
        encrypted_sig = url_data["s"]

        ASSETS_RE = /"assets":.+?"js":\s*("[^"]+")/
        m = ASSETS_RE.match(video_webpage)
        player_url = m[1]

        signature = decrypt_signature(encrypted_sig, video_id, player_url)

        url += "&signature=" + signature
      end
    end

    def decrypt_signature(s, video_id, player_url)
      raise "error" if player_url.empty?

      if player_url =~ /^\/\//
        player_url = "https:" + player_url
      elsif not player_url =~ /^https?:\/\//
        player_url = "https://www.youtube.com#{player_url}"
      end
    end

    def extract_signature_function(video_id, player_url, example_sig)
      A = /.*?-(?<id>[a-zA-Z0-9_-]+)(?:\/watch_as3|\/html5player(?:-new)?|\/base)?\.(?<ext>[a-z]+)$/
      id_m = A.match(player_url)

      player_type = id_m.try &.["ext"]
      player_id   = id_m.try &.["id"]

      func_id = '%s_%s_%s' % [player_type, player_id, example_sig.split('.').map(&.size).join('.')]
      # assert os.path.basename(func_id) == func_id

      # use cache find spec
      # cache_spec = cache_load('youtube-sigfuncs', func_id)

      puts "Downloading %s player %s" % [player_type, player_id]

      case player_type
      when "js"
        code = InfoExtractor.new(@@video_id).download_webpage(player_url)
        res = parse_sig_js(code)
        
        break
      when "swf"

        break
      else
        raise "Invalid player type %r" % player_type
      end

    end


    video_info["url_encoded_fmt_stream_map"]?
    video_info["adaptive_fmts"]?

    for url_data_str in encoded_url_map.split(','):
        url_data = compat_parse_qs(url_data_str)
        if 'itag' not in url_data or 'url' not in url_data:
            continue
        format_id = url_data['itag'][0]
        url = url_data['url'][0]

        if 'sig' in url_data:
            url += '&signature=' + url_data['sig'][0]
        elif 's' in url_data:
            encrypted_sig = url_data['s'][0]
            ASSETS_RE = r'"assets":.+?"js":\s*("[^"]+")'


            jsplayer_url_json = self._search_regex(
                ASSETS_RE,
                embed_webpage if age_gate else video_webpage,
                'JS player URL (1)', default=None)
            if not jsplayer_url_json and not age_gate:
                # We need the embed website after all
                if embed_webpage is None:
                    embed_url = proto + '://www.youtube.com/embed/%s' % video_id
                    embed_webpage = self._download_webpage(
                        embed_url, video_id, 'Downloading embed webpage')
                jsplayer_url_json = self._search_regex(
                    ASSETS_RE, embed_webpage, 'JS player URL')

            player_url = json.loads(jsplayer_url_json)
            if player_url is None:
                player_url_json = self._search_regex(
                    r'ytplayer\.config.*?"url"\s*:\s*("[^"]+")',
                    video_webpage, 'age gate player URL')
                player_url = json.loads(player_url_json)

            if self._downloader.params.get('verbose'):
                if player_url is None:
                    player_version = 'unknown'
                    player_desc = 'unknown'
                else:
                    if player_url.endswith('swf'):
                        player_version = self._search_regex(
                            r'-(.+?)(?:/watch_as3)?\.swf$', player_url,
                            'flash player', fatal=False)
                        player_desc = 'flash player %s' % player_version
                    else:
                        player_version = self._search_regex(
                            [r'html5player-([^/]+?)(?:/html5player(?:-new)?)?\.js', r'(?:www|player)-([^/]+)/base\.js'],
                            player_url,
                            'html5 player', fatal=False)
                        player_desc = 'html5 player %s' % player_version

                parts_sizes = self._signature_cache_id(encrypted_sig)
                self.to_screen('{%s} signature length %s, %s' %
                               (format_id, parts_sizes, player_desc))

            signature = self._decrypt_signature(
                encrypted_sig, video_id, player_url, age_gate)
            url += '&signature=' + signature
        if 'ratebypass' not in url:
            url += '&ratebypass=yes'

        dct = {
            'format_id': format_id,
            'url': url,
            'player_url': player_url,
        }
        if format_id in self._formats:
            dct.update(self._formats[format_id])
        if format_id in formats_spec:
            dct.update(formats_spec[format_id])

        # Some itags are not included in DASH manifest thus corresponding formats will
        # lack metadata (see https://github.com/rg3/youtube-dl/pull/5993).
        # Trying to extract metadata from url_encoded_fmt_stream_map entry.
        mobj = re.search(r'^(?P<width>\d+)[xX](?P<height>\d+)$', url_data.get('size', [''])[0])
        width, height = (int(mobj.group('width')), int(mobj.group('height'))) if mobj else (None, None)

        more_fields = {
            'filesize': int_or_none(url_data.get('clen', [None])[0]),
            'tbr': float_or_none(url_data.get('bitrate', [None])[0], 1000),
            'width': width,
            'height': height,
            'fps': int_or_none(url_data.get('fps', [None])[0]),
            'format_note': url_data.get('quality_label', [None])[0] or url_data.get('quality', [None])[0],
        }
        for key, value in more_fields.items():
            if value:
                dct[key] = value
        type_ = url_data.get('type', [None])[0]
        if type_:
            type_split = type_.split(';')
            kind_ext = type_split[0].split('/')
            if len(kind_ext) == 2:
                kind, _ = kind_ext
                dct['ext'] = mimetype2ext(type_split[0])
                if kind in ('audio', 'video'):
                    codecs = None
                    for mobj in re.finditer(
                            r'(?P<key>[a-zA-Z_-]+)=(?P<quote>["\']?)(?P<val>.+?)(?P=quote)(?:;|$)', type_):
                        if mobj.group('key') == 'codecs':
                            codecs = mobj.group('val')
                            break
                    if codecs:
                        dct.update(parse_codecs(codecs))
        formats.append(dct)


  end

  def self.get_ytplayer_config(webpage)
    config = /\;ytplayer\.config\s*=\s*(?<config>{.+?})\;ytplayer/.match(webpage).try(&.["config"])
    config = config ? config.to_s : "{}"
    JSON.parse(config).as_h
  end

  def self.extract_id(url)
    video_id = VALID_URL.match(url).try(&.["video_id"]).to_s
    raise "Invalid URL: #{url}" if video_id.empty?
    video_id
  end
end
