require "./spec_helper"

describe Decipherer do
  describe "#parse_chiper" do
    it "parse_cipher" do
      sig_id = "vfl5-0t5t"
      decode = "s1 w44 r s1"
      cipher = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"
      # plain_text = "081C25E3EF0A104B991C8B9C9A77D488D2963392.C547A4351C5C54AFA33BDE625FCE99203AB9CD44"

      url = "https://s.ytimg.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      Decipherer.new(cipher, url).parse_cipher().should eq decode
    end
  end
end
