require "../spec_helper"

describe Youtube::Webpage do
  describe "#download_webpage" do
    it "content body" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      Youtube::Webpage.new(url).content.should contain "<!DOCTYPE html>"
    end

    pending do
      it "error link" do
        url = "https://error.link/"
        Youtube::Webpage.new(url).should expect error
      end
    end
  end

  describe "#extract_player_url" do
    it "get player_url" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      player_url = %r(https://www.youtube.com/yts/jsbin/(.+)/base.js)

      Youtube::Webpage.new(url).extract_player_url.should match player_url
    end

    pending do
      it "error" do
        url = "https://www.google.com/"
        Youtube::Webpage.new(url).extract_player_url.should be error
      end
    end
  end

  describe "#extract_sts" do
    it "get sts" do
      url = "https://www.youtube.com/embed/iDfZua4IS4A"
      Youtube::Webpage.new(url).extract_sts.should match %r(^(|\d+)$)
    end
  end
end
