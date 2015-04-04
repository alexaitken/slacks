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
    puts "[VentSource] event stream started kill: #{@kill}"
    while !@kill
      puts "find more events #{last_event_id}"
      event_store.events_since(last_event_id).each do |event|
        processor.process_event(event)
        self.last_event_id = event.event_id
      end
      sleep 5
    end
    puts "[VentSource] event stream shuting down. #{@kill}"
  end

  private

  attr_reader :processor, :event_store
  attr_accessor :last_event_id
end
