require "http/client"
require "./apply_cipher"
require "./parse_urlmap"
require "../helpers/uri_helper"

class Youtube
  def self.get_video_info(video_id, sts=nil)
    @@base_uri = "https://www.youtube.com"
    url  = "/get_video_info?video_id=#{video_id}"
    url += "&eurl=#{@@base_uri}/watch?v=#{video_id}"
    url += "&sts=#{sts}" if sts
    r = HTTP::Client.get("#{@@base_uri}#{url}")

    d = URI.decode_www_form(r.body).to_h
    return d if d["status"] == "fail"

    data = Hash(String, String | Int32 | Bool | Array(String) | Array(Hash(String, String)) | Float64 ).new
    d.each do |k, v|
      case k
      when "keywords", "fmt_list", "watermark"
        data[k] = d[k].to_s.split(",")
      when "use_cipher_signature", "has_cc"
        data[k] = d[k].downcase == "true"
      when "allow_embed", "allow_ratings", "cc3_module", "cc_asr", "enablecsi", "is_listed", "iv3_module", "iv_allow_in_place_switch", "iv_load_policy", "muted", "no_get_video_log", "tmi"
        data[k] = d[k] == "1"
      when "cl", "default_audio_track_index", "idpj", "ldpj", "length_seconds", "timestamp", "view_count"
        data[k] = d[k].to_i
      when "avg_rating", "loudness"
        data[k] = d[k].to_f
      when "url_encoded_fmt_stream_map", "adaptive_fmts"
        # Int: "bitrate", "clen", "itag", "lmt", "projection_type"
        data[k] = parse_urlmap(d[k])
      end
    end
    p data
    data
  end
end
