class VentSource::EventStore
  include VentSource::IdGeneration

  def initialize
    @store = []
  end

  def store_version(aggregate_id, type, version, journal)
    journal.each_with_index do |event, idx|
      @store << {
        id: generate_id,
        aggregate_id: aggregate_id,
        type: type,
        sequence_number: idx,
        version: version,
        event_name: event.class.event_name,
        data: event.attributes,
        created_at: Time.now,
      }
    end
  end

  def events_for(id, type)
    @store.select { |event|
      event[:aggregate_id] == id && event[:type] == type
    }.map { |event|
      event[:event_name].camelize.constantize.new(event[:data])
    }
  end

  def ids_for_type(type)
    @store.select { |event|
      event[:type] == type
    }.map { |event|
      event[:aggregate_id]
    }.uniq
  end
end
