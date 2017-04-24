module Cache
  extend self

  @@path = "#{ENV["HOME"]}/.cache/crystal/youtube-retriever/"

  def load(player_url : String)
    full_path = @@path + name_from player_url

    File.exists?(full_path) ? File.read(full_path) : ""
  end

  def store(player_url : String, steps : String)
    full_path = @@path + name_from player_url

    Dir.mkdir_p(@@path)
    File.write(full_path, steps)
  end

  private def name_from(player_url : String)
    player_url.match(/jsbin\/(?<name>.+?)\//m).try(&.["name"]).to_s
  end
end
