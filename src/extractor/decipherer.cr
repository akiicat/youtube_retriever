require "../config"

class Decipherer
  getter url   : String
  getter steps : String

  def initialize(url : String = "")
    @url   = url
    @steps = Interpreter.decode_steps(url)
  end

  def decrypt(sig : String)
    @steps.split(" ").each do |op|
      op, n = op[0], op[1..-1].to_i? || 0
      # puts op, n
      sig = case op
      when 'r' then sig.reverse
      when 's' then sig[n..-1]
      when 'w' then sig.swap(0, n)
      end.to_s
    end
    sig
  end
end
