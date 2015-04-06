class VentSource::Projections
  class << self
    def run
      projections = VentSource.configuration.projections

      prepared_projections = projections.map do |projection_class|
        {
          projection: projection_class.new,
          event_stream: VentSource::EventStream.new(VentSource::ArEventStore.new)
        }
      end

      threads = prepared_projections.map do |prepared_projection|
        puts "[Starting projections] #{prepared_projection[:projection].projection_name}"
        Thread.new do
          prepared_projection[:projection].attach_to_event_stream(prepared_projection[:event_stream])
          puts "[Running projections] #{prepared_projection[:projection].projection_name}"
        end
      end
      threads.map(&:join)
    end
  end
end
