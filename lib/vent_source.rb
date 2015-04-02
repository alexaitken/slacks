module VentSource
  @@configuration = nil
  def self.configure
    @@configuration = Config.new
    yield @@configuration
  end

  def self.configuration
    @@configuration
  end

  class Config
    attr_reader :handlers

    def clear_handlers!
      @handlers = []
    end

    def define_handlers
      @handlers ||= []
      yield @handlers
    end
  end
end

