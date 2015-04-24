module VentSource
  @@configuration = nil
  def self.configure
    @@configuration = Config.new
    yield @@configuration
  end

  def self.configuration
    @@configuration
  end

  def self.logger
    configuration.logger
  end

  class Config
    attr_accessor :logger

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    def clear!
      @projections = []
    end

    def add_projections(*locations)
      @projections = @projections + locations
    end

    def projections
      @projections.each do |callable|
        callable.call
      end

      Projection.descendants
    end
  end
end
