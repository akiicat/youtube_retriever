module Youtube
  class Webpage
    property url : String
    property content : String

    def initialize(url : String)
      @url = url
      @content = download_webpage
    end

    private def download_webpage
      LOG.info "[DOWNLOAD] webpage: #{@url}"
      HTTP::Client.get(@url).body
    rescue
      LOG.error "[DOWNLOAD] can't download webpage: #{@url}"
      raise "can't download webpage "
    end

    def extract_player_url
      LOG.info "[EXTRACT] player url"
      player_url = @content.match(/"assets":.+?"js":\s*(?<url>"[^"]+")/).try(&.["url"]).to_s.as_json

      case player_url
        when /^\/\//				then "https:#{player_url}"
        when /^https?:\/\// then player_url
        else "https://www.youtube.com#{player_url}"
      end
    rescue
      LOG.error "[EXTRACT] can't find player url"
      raise "can't find player url"
    end

    def extract_sts
      LOG.info "[EXTRACT] sts"
      @content.match(/"sts":(?<sts>\d+),/).try(&.["sts"]).to_s
    rescue
      LOG.error "[EXTRACT] can't find sts"
      raise "can't find sts"
    end
  end
end
