require "spec"
require "../../src/helpers/uri_helper"

describe URI do
  it "#decode_www_form" do
    q1 = "url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26initcwndbps%3D2917500%26ip%3D61.220.182.115%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1481464250294058%26dur%3D284.839%26mime%3Dvideo%252Fmp4%26key%3Dyt6%26sparams%3Ddur%252Cei%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Cratebypass%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D22%26ratebypass%3Dyes%26pl%3D24%26source%3Dyoutube%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=22&type=video%2Fmp4%3B+codecs%3D%22avc1.64001F%2C+mp4a.40.2%22&quality=hd720&s=32E3D5A7E5C844B01F7E8049B3CDEC18DF37F5F0B.DFAD820780E2C111F65AE93FA69BBA2200775D0A"

    a1 = {
      "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&initcwndbps=2917500&ip=61.220.182.115&mt=1490753246&mv=m&ms=au&lmt=1481464250294058&dur=284.839&mime=video%2Fmp4&key=yt6&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=22&ratebypass=yes&pl=24&source=youtube&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0",
      "itag"=>"22",
      "type"=>"video/mp4; codecs=\"avc1.64001F, mp4a.40.2\"",
      "quality"=>"hd720",
      "s"=>"32E3D5A7E5C844B01F7E8049B3CDEC18DF37F5F0B.DFAD820780E2C111F65AE93FA69BBA2200775D0A"
    }

    URI.decode_www_form(q1).size.should eq a1.size
    URI.decode_www_form(q1).to_a.should eq a1.to_a
  end
end
