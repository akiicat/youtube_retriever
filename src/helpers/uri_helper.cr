require "uri"

class URI
  def self.decode_www_form(str)
    hsh = Hash(String, String | Bool).new
    URI.unescape(str).scan(/([^=;&]+)=([^;&]*)/).each do |h|
      hsh[h.try &.[1]] = h.try &.[2]
    end
    hsh
  end
end
