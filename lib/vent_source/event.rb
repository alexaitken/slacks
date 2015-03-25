module VentSource::Event
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      event_name base.name.split('::').last.underscore
    end
  end

  module ClassMethods
    def define_attributes(*attributes)
      @attributes ||= []
      symbolized_attributes = attributes.map(&:to_sym)
      @attributes = @attributes + symbolized_attributes
      symbolized_attributes.each do |attribute|
        define_method attribute do
          self.attributes[attribute]
        end
      end
    end

    def attribute_names
      @attributes.dup.freeze
    end

    def event_name(name = nil)
      @event_name = name if name != nil
      @event_name
    end
  end

  def initialize(attr = {})
    @attributes = {}
    attr.slice(*self.class.attribute_names).each do |name, value|
      @attributes[name] = value.try(:dup).freeze
    end
    @attributes.freeze
  end

  def attributes
    @attributes
  end
end
