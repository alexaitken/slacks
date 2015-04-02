class VentSource::EventStream
  event_stream.start_at(last_event_processed)

  def initialize(event_store)

    @unprocessed_events = []
  end

  def processor=(processor)
    @processor = processor
  end

  def start_at(event_id = nil)

    connect_to_event_store


  end

  def event_available(event)
  end

  private
  attr_reader :processor, :event_store
end
