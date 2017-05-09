require "../spec_helper"

describe Youtube::Retriever do
  describe "#extract_id" do
    context "should extract video id from" do
      it "url" do
        url = "https://www.youtube.com/watch?v=iDfZua4IS4A&has_verified=1"
        Youtube::Retriever.new(url).video_id.should eq "iDfZua4IS4A"
      end

      it "short url" do
        url = "https://youtu.be/iDfZua4IS4A"
        Youtube::Retriever.new(url).video_id.should eq "iDfZua4IS4A"
      end

      it "video id" do
        url = "iDfZua4IS4A"
        Youtube::Retriever.new(url).video_id.should eq "iDfZua4IS4A"
      end
    end
  end

  describe "#initialize" do
    it "success" do
      Youtube::Retriever.new("iDfZua4IS4A").video_info.content["status"].should eq "ok"
    end

    it "error" do
      Youtube::Retriever.new("iDfZua4IS4a").video_info.content["status"].should eq "fail"
    end
  end

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

  describe "#video_info" do
    it "title" do
      Youtube::Retriever.video_info("iDfZua4IS4A")[:author].should eq "黑市音樂"
    end

    it "no streams url" do
      Youtube::Retriever.video_info("iDfZua4IS4A")[:streams]?.should eq nil
    end
  end

  describe "#get_video_urls" do
    it "sort by video resolution" do
      Youtube::Retriever.get_video_urls("iDfZua4IS4A").first[:itag].should eq "22"
    end

    it "count" do
      rtn = Youtube::Retriever.get_video_urls("iDfZua4IS4A")
      rtn.select { |x| x[:comment] == "default" }.size.should eq rtn.size
    end

    it "not be zero" do
      Youtube::Retriever.get_video_urls("iDfZua4IS4A").size.should_not eq 0
    end
  end

  describe "#get_audio_urls" do
    it "audio_only" do
      Youtube::Retriever.get_audio_urls("iDfZua4IS4A").first[:itag].should eq "251"
    end

    it "count" do
      rtn = Youtube::Retriever.get_audio_urls("iDfZua4IS4A")
      rtn.select { |x| x[:comment] == "audio only" }.size.should eq rtn.size
    end

    it "not be zero" do
      Youtube::Retriever.get_audio_urls("iDfZua4IS4A").size.should_not eq 0
    end
  end
end
