require "../spec_helper"

describe Youtube::Retriever do
  describe "#dump_json" do
    it "non cipher" do
      Youtube::Retriever.dump_json("iDfZua4IS4A")[:author].should eq "黑市音樂"
    end

    it "vevo" do
      Youtube::Retriever.dump_json("6YpYgT2B6Hg")[:author].should eq "Vevo dscvr"
    end

    it "age gate" do
      Youtube::Retriever.dump_json("Ci6lMQNLKZU")[:author].should eq "Mortal Kombat Community"
    end

    it "viewer under 300" do
      Youtube::Retriever.dump_json("esGPFvKCkOY")[:author].should eq "Phoebe Huang"
    end
  end
  
  # describe "#extract_id" do
  #   context "should extract video id from" do
  #     it "url" do
  #       url = "https://www.youtube.com/watch?v=iDfZua4IS4A&has_verified=1"
  #       Youtube::InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
  #     end
  #
  #     it "short url" do
  #       url = "https://youtu.be/iDfZua4IS4A"
  #       Youtube::InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
  #     end
  #
  #     it "video id" do
  #       url = "iDfZua4IS4A"
  #       Youtube::InfoExtractor.extract_id(url).should eq "iDfZua4IS4A"
  #     end
  #   end
  # end

  # describe "#get_video_info" do
  #   it "should get video info" do
  #     video_id = "iDfZua4IS4A"
  #     url = ""
  #     Youtube::Webpage.new(url).get_video_info(video_id).has_key?("token").should be_true
  #   end
  # end
end
