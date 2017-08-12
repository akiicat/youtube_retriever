require "../spec_helper"

describe Youtube::Webpage do
  describe "#download_webpage" do
    it "content body" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      Youtube::Webpage.new(url).content.should contain "<!DOCTYPE html>"
    end

    it "error link" do
      expect_raises do
        Youtube::Webpage.new("https://error.link/")
      end
    end
  end

  describe "#extract_player_url" do
    it "get player_url" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      player_url = %r(https://www.youtube.com/yts/jsbin/(.+)/base.js)

      Youtube::Webpage.new(url).extract_player_url.should match player_url
    end

    it "error page" do
      expect_raises do
        Youtube::Webpage.new("https://www.google.com/").extract_player_url
      end
    end
  end

  describe "#extract_sts" do
    it "get sts" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      Youtube::Webpage.new(url).extract_sts.should match %r(^(\d*)$)
    end
  end


  describe "#extract_video_info" do
    it "video_info" do
      video_id = "6YpYgT2B6Hg"
      url = "https://www.youtube.com/get_video_info?&video_id=#{video_id}&el=embedded&ps=default&gl=US&hl=en&sts=&eurl=https://www.google.com"
      Youtube::Webpage.new(url).extract_video_info["video_id"].should eq video_id
    end
  end
end
