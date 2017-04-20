require "./extractor_spec"

describe InfoExtractor do
  describe "#download_webpage" do
    it "should content body" do
      video_id = "iDfZua4IS4A"
      url      = "https://www.youtube.com/watch?v=#{video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
      InfoExtractor.download_webpage(url).should contain "<!DOCTYPE html>"
    end
  end

  describe "#extract_id" do
    context "should extract video id from" do
      it "url" do
        url = "https://www.youtube.com/watch?v=iDfZua4IS4A&has_verified=1"
        InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
      end

      it "short url" do
        url = "https://youtu.be/iDfZua4IS4A"
        InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
      end

      it "video id" do
        url = "iDfZua4IS4A"
        InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
      end
    end
  end

  describe "#get_video_info" do
    it "should get video info" do
      video_id = "iDfZua4IS4A"
      InfoExtractor.get_video_info(video_id).has_key?("token").should be_true
    end
  end

  describe "#extract_player_url" do
    it "should extract player_url from webpage" do
      video_id = "iDfZua4IS4A"
      url = "https://www.youtube.com/watch?v=#{video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
      video_webpage = InfoExtractor.download_webpage(url)
      player_url = "https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js"

      InfoExtractor.extract_player_url(video_webpage).should eq player_url
    end
  end
end
