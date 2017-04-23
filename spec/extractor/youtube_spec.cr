require "../spec_helper"

describe Youtube do
  describe "#dump_json" do
    it "extract video info" do
      Youtube.dump_json("iDfZua4IS4A")[:author].should eq "黑市音樂"
    end
  end
end
