# decode_steps("https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js")
# => "s1 w44 r s1"

sig_id = "vfl5-0t5t"
steps  = "s1 w44 r s1"
url    = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"


require "./extractor_spec"

describe Interpreter do
  it "#decode_steps" do
    sig_id = "vfl5-0t5t"
    url    = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
    steps  = "s1 w44 r s1"

    Interpreter.decode_steps(url).should eq steps
  end

  it "#extract_signature" do
    sig_id  = "vfl5-0t5t"
    url     = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
    js_code = InfoExtractor.download_webpage(url)
    decoder = [
      {obj_name: "yc", member: "hG", args: "a,1" , index: "1"  },
      {obj_name: "yc", member: "Kx", args: "a,44", index: "44" },
      {obj_name: "yc", member: "Dt", args: "a,23", index: "23" },
      {obj_name: "yc", member: "hG", args: "a,1" , index: "1"  }
    ]

    Interpreter.extract_signature(js_code).should eq decoder
  end

  it "#interpret_statement" do
    stmt = "yc.Kx(a,44)"
    rtn  = {
      obj_name: "yc",
      member:   "Kx",
      args:     "a,44",
      index:    "44"
    }

    Interpreter.interpret_statement(stmt).should eq rtn
  end

  it "#extract_actions" do
    sig_id   = "vfl5-0t5t"
    url      = "https://www.youtube.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
    js_code  = InfoExtractor.download_webpage(url)

    obj_name = "yc"
    actions  = {
      "Dt" => "r",
      "Kx" => "w",
      "hG" => "s"
    }

    Interpreter.extract_actions(js_code, obj_name).should eq actions
  end
end
