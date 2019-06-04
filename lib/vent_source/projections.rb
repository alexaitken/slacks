class VentSource::Projections
  class << self
    def run
      VentSource::ProjectionStore
      prepared_projections = projections.map do |projection_class|
        {
          projection: projection_class.new,
          event_stream: VentSource::EventStream.new(VentSource::ArEventStore.new)
        }
      end

      threads = prepared_projections.map do |prepared_projection|
        VentSource.logger.info "[Starting projections] #{prepared_projection[:projection].projection_name}"
        Thread.new do
          prepared_projection[:projection].attach_to_event_stream(prepared_projection[:event_stream])
          VentSource.logger.debug "[Running projections] #{prepared_projection[:projection].projection_name}"
        end
      end
      threads.map(&:join)
    end

    def reset(projection_name)
      projection = projections.find do |projection_class|
        projection_class.projection_name == projection_name
      end

      raise "Unknown projection #{projection_name}" unless projection

      projection.reset
    end

    def reset_all
      projections.each do |projection_class|
        projection_class.reset
      end
    end

    def projections
      VentSource.configuration.projections
    end
  end
end
