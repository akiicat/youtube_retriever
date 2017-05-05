require "../spec_helper"

describe Youtube::Interpreter do
  it "#decode_steps" do
    url = "https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js"
    steps = "s1 w44 r s1"

    Youtube::Interpreter.decode_steps(url).should eq steps
  end

  it "#extract_signature" do
    url = "https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js"
    js_code = Youtube::Webpage.new(url).content
    decoder = [
      {obj_name: "yc", member: "hG", args: "a,1" , index: "1"  },
      {obj_name: "yc", member: "Kx", args: "a,44", index: "44" },
      {obj_name: "yc", member: "Dt", args: "a,23", index: "23" },
      {obj_name: "yc", member: "hG", args: "a,1" , index: "1"  }
    ]

    Youtube::Interpreter.extract_signature(js_code, url).should eq decoder
  end

  it "#interpret_statement" do
    stmt = "yc.Kx(a,44)"
    rtn = {
      obj_name: "yc",
      member:   "Kx",
      args:     "a,44",
      index:    "44"
    }

    Youtube::Interpreter.interpret_statement(stmt).should eq rtn
  end

  it "#extract_actions" do
    url = "https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js"
    js_code  = Youtube::Webpage.new(url).content

    obj_name = "yc"
    actions = {
      "Dt" => "r",
      "Kx" => "w",
      "hG" => "s"
    }

    Youtube::Interpreter.extract_actions(js_code, obj_name).should eq actions
  end
end
