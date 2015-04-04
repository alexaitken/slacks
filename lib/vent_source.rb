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

