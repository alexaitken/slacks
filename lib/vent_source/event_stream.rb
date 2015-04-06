class VentSource::EventStream
  def initialize(event_store)
    @event_store = event_store
  end

  def processor=(processor)
    @processor = processor
  end

  def start
    start_at
  end

  def kill
    @kill = true
  end

  def start_at(event_id = nil)
    self.last_event_id = event_id
    process
  end

  def process
    log "event stream started kill: #{@kill}"
    while !@kill
      log "find more events #{last_event_id}"
      event_store.events_since(last_event_id).each do |event|
        processor.process_event(event)
        self.last_event_id = event.event_id
      end
      sleep 5
    end
    log "event stream shuting down. #{@kill}"
  end

  private

  attr_reader :processor, :event_store
  attr_accessor :last_event_id

  def log(message)
    puts "[VentSource] #{processor.projection_name} #{message}"
  end

end
