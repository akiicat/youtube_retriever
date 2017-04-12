require "./spec_helper"

describe InfoExtractor do
  describe "#download_webpage" do
    it "content body" do
      video_id = "iDfZua4IS4A"
      url = "https://www.youtube.com/watch?v=#{video_id}&gl=US&hl=en&has_verified=1&bpctr=9999999999"
      InfoExtractor.new(video_id).download_webpage(url).should contain "<!DOCTYPE html>"
    end
  end
end
