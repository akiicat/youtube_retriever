require "spec"
require "../../src/youtube/parse_urlmap"

describe Youtube do
  it "#parse_urlmap" do
    q1 = "url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26initcwndbps%3D2917500%26ip%3D61.220.182.115%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1481464250294058%26dur%3D284.839%26mime%3Dvideo%252Fmp4%26key%3Dyt6%26sparams%3Ddur%252Cei%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Cratebypass%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D22%26ratebypass%3Dyes%26pl%3D24%26source%3Dyoutube%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=22&type=video%2Fmp4%3B+codecs%3D%22avc1.64001F%2C+mp4a.40.2%22&quality=hd720&s=32E3D5A7E5C844B01F7E8049B3CDEC18DF37F5F0B.DFAD820780E2C111F65AE93FA69BBA2200775D0A,url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26clen%3D30245573%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26gir%3Dyes%26initcwndbps%3D2917500%26ip%3D61.220.182.115%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1431610617920198%26dur%3D0.000%26mime%3Dvideo%252Fwebm%26key%3Dyt6%26sparams%3Dclen%252Cdur%252Cei%252Cgir%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Cratebypass%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D43%26ratebypass%3Dyes%26pl%3D24%26source%3Dyoutube%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=43&type=video%2Fwebm%3B+codecs%3D%22vp8.0%2C+vorbis%22&quality=medium&s=E679DFCDC5A78077CF27C99801C7CE8C96DF1A7FD.EB4B160AF4E664531D988A4763813674315B9D0B,url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26clen%3D25028066%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26gir%3Dyes%26initcwndbps%3D2917500%26ip%3D61.220.182.115%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1481463181561351%26dur%3D284.839%26mime%3Dvideo%252Fmp4%26key%3Dyt6%26sparams%3Dclen%252Cdur%252Cei%252Cgir%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Cratebypass%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D18%26ratebypass%3Dyes%26pl%3D24%26source%3Dyoutube%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=18&type=video%2Fmp4%3B+codecs%3D%22avc1.42001E%2C+mp4a.40.2%22&quality=medium&s=CF7CDDF2CE786F80B1BD35389925DEB2BF1854F07.DDC63AA73AFF9440E8410A3C2B0BB47743494645,url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26clen%3D8135888%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26gir%3Dyes%26initcwndbps%3D2917500%26source%3Dyoutube%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1431608743101235%26dur%3D285.001%26mime%3Dvideo%252F3gpp%26key%3Dyt6%26sparams%3Dclen%252Cdur%252Cei%252Cgir%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D36%26pl%3D24%26ip%3D61.220.182.115%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=36&type=video%2F3gpp%3B+codecs%3D%22mp4v.20.3%2C+mp4a.40.2%22&quality=small&s=51DE85746891BB2A8BB33A1781ECFFA0889424E48.D756CBE017A1CC14C57F4DA423C30572AED7AC05,url=https%3A%2F%2Fr5---sn-ipoxu-un56.googlevideo.com%2Fvideoplayback%3Fmm%3D31%26clen%3D2910217%26mn%3Dsn-ipoxu-un56%26id%3Do-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p%26gir%3Dyes%26initcwndbps%3D2917500%26source%3Dyoutube%26mt%3D1490753246%26mv%3Dm%26ms%3Dau%26lmt%3D1431608692852431%26dur%3D284.908%26mime%3Dvideo%252F3gpp%26key%3Dyt6%26sparams%3Dclen%252Cdur%252Cei%252Cgir%252Cid%252Cinitcwndbps%252Cip%252Cipbits%252Citag%252Clmt%252Cmime%252Cmm%252Cmn%252Cms%252Cmv%252Cpl%252Crequiressl%252Csource%252Cupn%252Cexpire%26expire%3D1490774975%26requiressl%3Dyes%26itag%3D17%26pl%3D24%26ip%3D61.220.182.115%26ei%3DXxfbWLniCcKO4AKpkoXgDw%26upn%3DQW9MWyooct4%26ipbits%3D0&itag=17&type=video%2F3gpp%3B+codecs%3D%22mp4v.20.3%2C+mp4a.40.2%22&quality=small&s=7D49F5164178DAE719A41099CE2B22AE0258727EC.EBC5F68EE00D6A6391E94AD463860BCB1762AEBB"

    a1 = [
      {
        "itag"=>22, "quality"=>"hd720",
        "s"=>"32E3D5A7E5C844B01F7E8049B3CDEC18DF37F5F0B.DFAD820780E2C111F65AE93FA69BBA2200775D0A",
        "type"=>"video/mp4; codecs=\"avc1.64001F, mp4a.40.2\"", "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&initcwndbps=2917500&ip=61.220.182.115&mt=1490753246&mv=m&ms=au&lmt=1481464250294058&dur=284.839&mime=video%2Fmp4&key=yt6&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=22&ratebypass=yes&pl=24&source=youtube&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0&signature=45770022ABB96AF39EA56F111C2E087028DAFD.B0F5F73FD81CEDC3B9408E7F10B4D8C5E7A5D"
      },
      {
        "itag"=>43,
        "quality"=>"medium",
        "s"=>"E679DFCDC5A78077CF27C99801C7CE8C96DF1A7FD.EB4B160AF4E664531D988A4763813674315B9D0B",
        "type"=>"video/webm; codecs=\"vp8.0, vorbis\"", "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&clen=30245573&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&gir=yes&initcwndbps=2917500&ip=61.220.182.115&mt=1490753246&mv=m&ms=au&lmt=1431610617920198&dur=0.000&mime=video%2Fwebm&key=yt6&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=43&ratebypass=yes&pl=24&source=youtube&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0&signature=89B5134763183674A889D135466E4FA061B4BE.DF7A1FD69C8EC7C10899C72FC770D7A5CDCFD"
      },
      {
        "itag"=>18,
        "quality"=>"medium",
        "s"=>"CF7CDDF2CE786F80B1BD35389925DEB2BF1854F07.DDC63AA73AFF9440E8410A3C2B0BB47743494645",
        "type"=>"video/mp4; codecs=\"avc1.42001E, mp4a.40.2\"", "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&clen=25028066&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&gir=yes&initcwndbps=2917500&ip=61.220.182.115&mt=1490753246&mv=m&ms=au&lmt=1481463181561351&dur=284.839&mime=video%2Fmp4&key=yt6&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=18&ratebypass=yes&pl=24&source=youtube&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0&signature=649434774BB0B2C3A0148E0449FFA37AA36CDD.70F4581FB2BED52998353DB1B08F687EC2FDD"
      },
      {
        "itag"=>36,
        "quality"=>"small",
        "s"=>"51DE85746891BB2A8BB33A1781ECFFA0889424E48.D756CBE017A1CC14C57F4DA423C30572AED7AC05",
        "type"=>"video/3gpp; codecs=\"mp4v.20.3, mp4a.40.2\"", "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&clen=8135888&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&gir=yes&initcwndbps=2917500&source=youtube&mt=1490753246&mv=m&ms=au&lmt=1431608743101235&dur=285.001&mime=video%2F3gpp&key=yt6&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=36&pl=24&ip=61.220.182.115&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0&signature=BA7DEA27503C324AD4F75C41CC1A710EBC657D.84E4249880AFFCE1871A33BB8A2BC19864758"
      }, {
        "itag"=>17,
        "quality"=>"small",
        "s"=>"7D49F5164178DAE719A41099CE2B22AE0258727EC.EBC5F68EE00D6A6391E94AD463860BCB1762AEBB",
        "type"=>"video/3gpp; codecs=\"mp4v.20.3, mp4a.40.2\"", "url"=>"https://r5---sn-ipoxu-un56.googlevideo.com/videoplayback?mm=31&clen=2910217&mn=sn-ipoxu-un56&id=o-AApYzSAoVZcOSbj-yOws8sHDB4DHHKSEedU71E1ZFa4p&gir=yes&initcwndbps=2917500&source=youtube&mt=1490753246&mv=m&ms=au&lmt=1431608692852431&dur=284.908&mime=video%2F3gpp&key=yt6&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Crequiressl%2Csource%2Cupn%2Cexpire&expire=1490774975&requiressl=yes&itag=17&pl=24&ip=61.220.182.115&ei=XxfbWLniCcKO4AKpkoXgDw&upn=QW9MWyooct4&ipbits=0&signature=DA2671BCB068364DA49E1936A6D00EE86F5CBE.CE7278520EA22B2EC99014A917EAE8714615F"
      }
    ]
    # 
    # p "--"
    # p Youtube.parse_urlmap(q1).to_a.first
    # p "-----"
    # p a1.to_a.first
    # p "--"

    Youtube.parse_urlmap(q1).size.should eq a1.size
    Youtube.parse_urlmap(q1).to_a.should eq a1.to_a
  end
end
