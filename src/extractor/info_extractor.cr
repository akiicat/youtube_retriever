require "../config"

class InfoExtractor
  def self.download_webpage(url, tries = 1, timeout = 5)
    response = ""
    loop do
      begin
        LOG.info "#{url}: Downloading webpage"
        response = HTTP::Client.get(url).body
        break
      rescue e
        raise e if (tries -= 1) <= 0
        LOG.info "#{url}: Waiting for #{timeout}s seconds"
        sleep(timeout)
      end
    end
    response
  end
end
