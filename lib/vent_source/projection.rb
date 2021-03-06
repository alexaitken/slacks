class VentSource::Projection
  @projection_name = nil

  def self.projection_name(name = nil)
    @projection_name = name unless name.nil?
    @projection_name
  end

  def self.reset
    reset_projection_records
    VentSource::ProjectionStore.where(name: projection_name).delete_all
  end

  def self.reset_projection_records
    raise NotImplementedError
  end

  def last_event_processed
    @projection = VentSource::ProjectionStore.find_or_create_by(name: projection_name)
    @projection.last_event_id
  end

  def attach_to_event_stream(event_stream)
    VentSource.logger.info "[VentSource] #{projection_name} attaching"
    event_stream.processor = self
    event_stream.start_at(last_event_processed)
  end

  def process_event(event)
    VentSource.logger.info "[VentSource] #{projection_name} Processing event #{event}"
    public_send(event.name, event) if respond_to?(event.name)
    event_processed(event)
    true
  end

  def event_processed(event)
    @projection.update_attributes(last_event_id: event.event_id, last_event_created_at: event.created_at)
  end

  def projection_name
    self.class.projection_name
  end
end
