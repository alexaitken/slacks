class VentSource::Projections
  class << self
    def run
      projections = VentSource.configuration.projections

      threads = []

      projections.each do |projection_class|
        puts "[Starting projections] #{projection_class.projection_name}"
        threads << Thread.new do
          projection = projection_class.new
          event_stream = VentSource::EventStream.new(VentSource::ArEventStore.new)
          projection.attach_to_event_stream(event_stream)
        end
        puts "[Running projections] #{projection_class.projection_name}"
      end

      threads.map(&:join)
    end
  end
end
