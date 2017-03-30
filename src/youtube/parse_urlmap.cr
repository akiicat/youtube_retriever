require "./apply_cipher"
require "../helpers/uri_helper"

class Youtube
  def self.parse_urlmap(str)
    str.to_s.split(",").map do |s|
      hsh = URI.decode_www_form(s).to_h
      hsh.each do |k, v|
        hsh[k] = v
        case k
        when "s"
          sig = apply_cipher(v)
          # hsh["decoded_signature"] = sig
          hsh["url"] = "#{hsh["url"]}&signature=#{sig}"
        end
      end
      hsh
    end
  end
end
