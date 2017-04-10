require "./spec_helper"

describe Youtube do


  describe "#_real_extract" do
    pending "extract youtube video info" do

    end
  end

  describe "#extract_id" do
    it "extract video id from youtube.com" do
      url = "https://www.youtube.com/watch?v=iDfZua4IS4A&has_verified=1"
      Youtube.extract_id(url).should eq "iDfZua4IS4A"
    end

    it "extract video id if from youtu.be" do
      url = "https://youtu.be/iDfZua4IS4A"
      Youtube.extract_id(url).should eq "iDfZua4IS4A"
    end

    it "only video id" do
      url = "iDfZua4IS4A"
      Youtube.extract_id(url).should eq "iDfZua4IS4A"
    end
  end
end
