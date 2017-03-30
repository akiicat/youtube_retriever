require "spec"
require "../../src/youtube/get_video_info"

describe Youtube do
  it "#get_video_info" do
    Youtube.get_video_info("iDfZua4IS4A").should_not be nil
  end
end
