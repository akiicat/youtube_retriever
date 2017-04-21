require "../config"

class Decipherer
  property url   : String
  property steps : String

  def initialize(@url = "", @steps = "")
  end

  def decrypt(sig : String)
    @steps = Interpreter.decode_steps(@url) if @steps.empty?
    @steps.split(" ").each do |op|
      op, n = op[0], op[1..-1].to_i? || 0
      sig = case op
      when 'r' then sig.reverse
      when 's' then sig[n..-1]
      when 'w' then sig.swap(0, n)
      end.to_s
    end
    sig
  end
end
