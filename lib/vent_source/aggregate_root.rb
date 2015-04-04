module VentSource
  class AggregateNotFound < StandardError; end

  module AggregateRoot
    def self.included(base)
      base.extend ClassMethods
    end

    attr_reader :id, :version

    def self.event_store
      VentSource::ArEventStore.new
    end

    def self.all(type)
      event_store.ids_for_type(type).map { |id| find(id, type) }
    end

    def self.find(id, type)
      events = event_store.events_for(id, type)
      raise AggregateNotFound if events.empty?

      aggregate = type.constantize.new
      aggregate.build_from_events(events)
      aggregate
    end

    module ClassMethods
      def find(id)
        AggregateRoot.find(id, self.to_s)
      end

      def all
        VentSource::AggregateRoot.all(self.to_s)
      end
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
      @version += 1
      @journal = []
    end

    def build_from_events(events)
      events.each do |version_info, event|
        apply_event(event)
        @version = version_info.first
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
