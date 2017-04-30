module Cache
  extend self

  @@path = "#{ENV["HOME"]}/.cache/crystal/youtube_retriever/"

  def load(player_url : String)
    full_path = @@path + name_from player_url

    steps = ""
    if File.exists?(full_path)
      steps = File.read(full_path)
      LOG.info "[CACHE] Load steps: '#{steps}' <- #{full_path}"
    else
      LOG.info "[CACHE] Not found: #{full_path}"
    end
    steps
  end

  def store(player_url : String, steps : String)
    full_path = @@path + name_from player_url

    LOG.info "[CACHE] Store steps: '#{steps}' -> #{full_path}"
    Dir.mkdir_p(@@path)
    File.write(full_path, steps)
  end

  private def name_from(player_url : String)
    player_url.match(/jsbin\/(?<name>.+?)\//m).try(&.["name"]).to_s
  end
end
