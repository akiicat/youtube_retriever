require "../helpers/string_helper"

class Youtube
  def self.apply_cipher(str)
    cipher = "a s3 r s2 r s1 r w67"
    cipher.split.each do |op|
      op = "#{op}0" if op[1..-1].empty?
      op, n = op[0], op[1..-1].to_i
      case op
      when 'r' then str = str.reverse
      when 's' then str = str[n..-1]
      when 'w' then str = str.swap(0, n)
      end
    end
    return str
  end
end
