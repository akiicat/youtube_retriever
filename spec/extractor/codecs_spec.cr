require "../spec_helper"

describe Codecs do
  describe "#format" do
    it "default" do
      rtn = {
        itag:             "22",
        container:        "MP4",
        video_resolution: "720p",
        video_encoding:   "H.264",
        video_profile:    "High",
        video_bitrate:    "42769",
        audio_encoding:   "AAC",
        audio_bitrate:    "192",
        comment:          "default"
      }
      Codecs.format("22").should eq rtn
    end

    it "video only" do
      rtn = {
        itag:             "137",
        container:        "MP4",
        video_resolution: "1080p",
        video_encoding:   "H.264",
        video_profile:    "High",
        video_bitrate:    "2.5–3",
        audio_encoding:   "",
        audio_bitrate:    "",
        comment:          "video only"
      }
      Codecs.format("137").should eq rtn
    end

    it "audio only" do
      rtn = {
        itag:             "251",
        container:        "WebM",
        video_resolution: "",
        video_encoding:   "",
        video_profile:    "",
        video_bitrate:    "",
        audio_encoding:   "Opus",
        audio_bitrate:    "160",
        comment:          "audio only"
      }
      Codecs.format("251").should eq rtn
    end

    it "live stream" do
      rtn = {
        itag:             "95",
        container:        "TS",
        video_resolution: "720p",
        video_encoding:   "H.264",
        video_profile:    "Main",
        video_bitrate:    "1.5–3",
        audio_encoding:   "AAC",
        audio_bitrate:    "256",
        comment:          "live stream"
      }
      Codecs.format("95").should eq rtn
    end
  end
end
