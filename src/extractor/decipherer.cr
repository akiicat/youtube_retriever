require "./interpreter"

class Decipherer
  property url   : String
  property steps : String

  include Interpreter

  def initialize(@url = "", @steps = "")
  end

  def decrypt(sig : String)
    @steps = decode_steps(@url) if @steps.empty?
    @steps.split(" ").each do |op|
      op, n = op[0], op[1..-1].to_i? || 0
      sig = case op
      when 'r' then sig.reverse
      when 's' then sig[n..-1]
      when 'w' then sig.swap(0, n)
      end.to_s
    end
    sig
  end

  def package(encoded_urls : String | Nil = nil)
    rtn = [] of Hash(Symbol, String)
    encoded_urls.to_s.split(",").each do |url_data_str|
      url_data = URI.decode_www_form(url_data_str)

      itag    = url_data["itag"]?
      url     = url_data["url"]?
      sig     = url_data["sig"]?
      s       = url_data["s"]?
      bitrate = url_data["bitrate"]?

      next if !itag || !url

      url += "&signature=#{sig}"        if sig
      url += "&signature=#{decrypt(s)}" if s
      url += "&ratebypass=yes"          if /ratebypass/ !~ url

      hsh = Codecs.format(itag)
      hsh[:url] = url
      hsh[:video_bitrate] = bitrate.as(String) if hsh[:comment] == "video only"
      hsh[:audio_bitrate] = bitrate.as(String) if hsh[:comment] == "audio only"

      rtn.push hsh
    end
    rtn
  end
end
