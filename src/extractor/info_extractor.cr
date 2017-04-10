require "http/client"

class InfoExtractor
  def self.download_webpage(url, video_id, tries = 1, timeout = 5)
    response = ""
    loop do
      begin
        puts "#{video_id}: Downloading webpage"
        response = HTTP::Client.get(url).body
        break
      rescue e
        raise e if (tries -= 1) <= 0
        sleep(timeout, video_id)
      end
    end
    response
  end

  def self.sleep(timeout, video_id, msg = nil)
    msg ||= "#{video_id}s: Waiting for #{timeout}s seconds"
    puts msg
    sleep(timeout)
  end
end
