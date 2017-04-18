require "./spec_helper"

describe Decipherer do
  describe "#decrypt" do
    it "should decrypted signature" do
      sig_id        = "vfl5-0t5t"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"
      decrypted_sig = "081C25E3EF0A104B991C8B9C9A77D488D2963392.C547A4351C5C54AFA33BDE625FCE99203AB9CD44"

      url = "https://s.ytimg.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      Decipherer.new(encrypted_sig, url).decrypt.should eq decrypted_sig
    end

    it "should have correct decoder steps" do
      sig_id        = "vfl5-0t5t"
      decoder_steps = "s1 w44 r s1"
      encrypted_sig = "334DC9BA30299ECF526EDB33AFA45C5C1534A745C.2934692D884D77A9C9B8C199B401A0FE3E52C1800"

      url = "https://s.ytimg.com/yts/jsbin/player-en_US-#{sig_id}/base.js"
      d = Decipherer.new(encrypted_sig, url)
      d.decrypt
      d.decoder_steps.join(" ").should eq decoder_steps
    end
  end
end
