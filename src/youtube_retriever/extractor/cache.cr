module Youtube
  class Cache
    PATH = "#{ENV["HOME"]}/.cache/crystal/youtube_retriever/"

    property player_url : String
    property full_path : String
    property steps : String

    def initialize(player_url : String)
      @player_url = player_url
      @full_path = PATH + url_name
      @steps = ""

      load
    end

    def load
      if File.exists?(@full_path)
        @steps = File.read(@full_path)
        LOG.info "[CACHE] Load steps: '#{@steps}' <- #{@full_path}"
      else
        LOG.info "[CACHE] Not found: #{@full_path}"
      end
      @steps
    end

    def store(steps : String)
      @steps = steps
      LOG.info "[CACHE] Store steps: '#{@steps}' -> #{@full_path}"
      Dir.mkdir_p(PATH)
      File.write(@full_path, @steps)
    end

    private def url_name
      @player_url.match(/jsbin\/(?<name>.+?)\//m).try(&.["name"]).to_s
    end
  end
end
