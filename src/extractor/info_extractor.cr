require "http/client"

class InfoExtractor

  def initialize(@video_id : String)
  end

  def download_webpage(url, tries = 1, timeout = 5)
    response = ""
    loop do
      begin
        puts "#{@video_id}: Downloading webpage"
        response = HTTP::Client.get(url).body
        break
      rescue e
        raise e if (tries -= 1) <= 0
        puts "#{@video_id}s: Waiting for #{timeout}s seconds"
        sleep(timeout)
      end
    end
    response
  end

  # def to_sleep(timeout, msg = nil)
  #   msg ||= "#{@@video_id}s: Waiting for #{timeout}s seconds"
  #   puts msg
  #   sleep(timeout)
  # end
end
