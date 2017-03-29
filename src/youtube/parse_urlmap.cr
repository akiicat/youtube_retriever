require "./apply_cipher"
require "../helpers/uri_helper"

class Youtube
  def self.parse_urlmap(str)
    str.split(",").map do |s|
      hsh = Hash(String, String | Int32).new
      h = URI.decode_www_form(s).to_h
      h.each do |k, v|
        case k
        when "bitrate", "clen", "itag", "lmt", "projection_type"
          hsh[k] = v.to_i
        else
          hsh[k] = v
        end

        if k == "s"
          sig = apply_cipher(v)
          # hsh["decoded_signature"] = sig
          hsh["url"] = "#{h["url"]}&signature=#{sig}"
        end
      end
      hsh
    end
  end
end
