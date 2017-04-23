require "./config"

module YouTube::Info
  extend self

  def dump_json(url)
    Youtube.dump_json("iDfZua4IS4A").to_json
  end
end
