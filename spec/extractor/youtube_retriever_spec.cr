require "../spec_helper"

describe YoutubeRetriever do
  describe "#dump_json" do
    it "non cipher" do
      YoutubeRetriever.dump_json("iDfZua4IS4A")[:author].should eq "黑市音樂"
    end

    it "vevo" do
      YoutubeRetriever.dump_json("6YpYgT2B6Hg")[:author].should eq "Vevo dscvr"
    end

    it "age gate" do
      YoutubeRetriever.dump_json("Ci6lMQNLKZU")[:author].should eq "Mortal Kombat Community"
    end

    it "viewer under 300" do
      YoutubeRetriever.dump_json("esGPFvKCkOY")[:author].should eq "Phoebe Huang"
    end
  end
end
