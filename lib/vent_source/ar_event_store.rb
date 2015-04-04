class VentSource::ArEventStore
  class Event < ActiveRecord::Base
    default_scope { order(:id) }

    def to_s
      "#{event_id} #{name}"
    end
  end

  include VentSource::IdGeneration

  def store_version(aggregate_id, type, version, journal)
    Event.transaction do
      journal.each_with_index.map do |event, idx|
        Event.create!(
          aggregate_id: aggregate_id,
          aggregate_type: type.to_s,
          sequence_number: idx,
          version: version,
          name: event.class.event_name,
          data: event.attributes,
        )
      end
    end
  end

  def events_for(id, type)
    Event.where(aggregate_id: id, aggregate_type: type).inject({}) { |events, event|
      events[[event.version, event.sequence_number]] = event.name.camelize.constantize.new(event.data.symbolize_keys)
      events
    }
  end

  def ids_for_type(type)
    Event.where(aggregate_type: type).pluck(:aggregate_id).uniq
  end

  def events_since(event_id)
    if event_id
      Event.where('id > ?', Event.find_by(event_id: event_id))
    else
      Event.all
    end
  end
end
