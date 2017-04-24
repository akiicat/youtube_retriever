require "json"

class String
  def swap(x, y)
    x = self.size + x if x < 0
    y = self.size + y if y < 0
    self.sub(x, self[y]).sub(y, self[x])
  end

  def as_json
    JSON.parse(self).to_s
  end
end
