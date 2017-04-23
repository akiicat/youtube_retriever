require "../spec_helper"

describe Decipherer do
  describe "#decrypt" do
    it "should decrypted signature" do
      sig_id        = "vfl5-0t5t"
      url           = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"
      decrypted_sig = "081C25E3EF0A104B991C8B9C9A77D488D2963392.C547A4351C5C54AFA33BDE625FCE99203AB9CD44"

      Decipherer.new(url: url).decrypt(encrypted_sig).should eq decrypted_sig
    end

    it "have correct decoder steps" do
      sig_id        = "vfl5-0t5t"
      url           = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      steps         = "s1 w44 r s1"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"

      decipher = Decipherer.new(url: url)
      decipher.decrypt(encrypted_sig)
      decipher.steps.should eq steps
    end

    it "initialize with empty url" do
      sig_id        = "vfl5-0t5t"
      url           = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"
      decrypted_sig = "081C25E3EF0A104B991C8B9C9A77D488D2963392.C547A4351C5C54AFA33BDE625FCE99203AB9CD44"

      decipher = Decipherer.new
      decipher.url = url
      decipher.decrypt(encrypted_sig).should eq decrypted_sig
    end

    it "multiple times in same class" do
      sig_id        = "vfl5-0t5t"
      url           = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"
      decrypted_sig = "081C25E3EF0A104B991C8B9C9A77D488D2963392.C547A4351C5C54AFA33BDE625FCE99203AB9CD44"

      decipher = Decipherer.new(url: url)
      3.times { decipher.decrypt(encrypted_sig).should eq decrypted_sig }
    end
  end

  describe "#package" do
    it "encoded urls" do
      steps         = "s1 w44 r s1"
      encoded_urls  = "s=7E1F6A3C68F299B3EC0DECBAE0D4922F86C9CD384.39C5AF8B8BABB67AEABFB81DE2EABFE2AEA413CACA&type=video%2Fmp4%3B codecs%3D%22avc1.64001F%2C mp4a.40.2%22&url=https%3A%2F%2Fr5---sn-ipoxu-un5k.googlevideo.com%2Fvideoplayback%3Finitcwndbps%3D2205000%26itag%3D22%26ms%3Dau%26mt%3D1492878027%26mv%3Dm%26dur%3D284.839%26id%3Do-AHjzD_jlVb7OPeo7vri720TTXI-8as0Pjw62-1Cxvb8Z%26sparams%3Ddur%252Cei%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Cratebypass%252Crequiressl%252Csource%252Cupn%252Cexpire%26pl%3D21%26ip%3D61.230.138.187%26mm%3D31%26mn%3Dsn-ipoxu-un5k%26lmt%3D1481464250294058%26ratebypass%3Dyes%26ipbits%3D0%26expire%3D1492899723%26mime%3Dvideo%252Fmp4%26requiressl%3Dyes%26source%3Dyoutube%26upn%3DfVVMw9DryI4%26ei%3DK4P7WKWEK5WX4AKSnJiACA%26key%3Dyt6&quality=hd720&itag=22"
      rtn = [{
        :itag => "22",
        :container => "MP4",
        :video_resolution => "720p",
        :video_encoding => "H.264",
        :video_profile => "High",
        :video_bitrate => "42769",
        :audio_encoding => "AAC",
        :audio_bitrate => "192",
        :comment => "default",
        :url => "https://r5---sn-ipoxu-un5k.googlevideo.com/videoplayback?initcwndbps=2205000&itag=22&ms=au&mt=1492878027&mv=m&dur=284.839&id=o-AHjzD_jlVb7OPeo7vri720TTXI-8as0Pjw62-1Cxvb8Z&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&pl=21&ip=61.230.138.187&mm=31&mn=sn-ipoxu-un5k&lmt=1481464250294058&ratebypass=yes&ipbits=0&expire=1492899723&mime=video%2Fmp4&requiressl=yes&source=youtube&upn=fVVMw9DryI4&ei=K4P7WKWEK5WX4AKSnJiACA&key=yt6&signature=CAC314AEA2EFBAE2ED18BFBAEA76BBAB8B8FAEC93.483DC9C68F2294D0EABCED0CE3B992F86C3A6F15"
      }]

      d = Decipherer.new
      d.steps = steps
      d.package(encoded_urls).should eq rtn
    end
  end
end
