class VentSource::Projection
  @@filters = []
  @@projection_name = nil

  def self.projection_name(name = nil)
    @@projection_name = name unless name.nil?
    @@projection_name
  end

  def self.define_filters
    yield @@filters
  end

  def last_event_processed
    projection = ProjectionStore.find_or_create_by(name: self.class.projection_name)
    projection.last_event_id
  end

  def attach_to_event_stream(event_stream)
    event_stream.processor = self
    event_stream.start_at(last_event_processed)
  end

  def process_event(event)
    return true unless @@filters.all? { |f| f.call(event) }
    public_send(event.name, event) if respond_to?(event.name)
  end
end
