module VentSource
  class AggregateNotFound < StandardError; end

  module AggregateRoot
    attr_reader :id, :version

    def self.event_store
      @event_store ||= VentSource::EventStore.new
    end

    def self.find(id, type)
      events = event_store.events_for(id, type)
      raise AggregateNotFound if events.empty?

      aggregate = type.constantize.new
      aggregate.build_from_events(events)
      aggregate
    end

    def initialize
      @version = 0
    end

    def apply(event)
      journal << event
      apply_event(event)
    end

    def apply_event(event)
      self.public_send(event.class.event_name.to_sym, event)
    end

    def commit
      event_store.store_version(id, self.class.to_s, version + 1, journal)
      @journal = []
    end

    def build_from_events(events)
      events.each do |event|
        apply_event(event)
      end
    end

    private

    def journal
      @journal ||= []
    end

    def event_store
      VentSource::AggregateRoot.event_store
    end
  end
end
