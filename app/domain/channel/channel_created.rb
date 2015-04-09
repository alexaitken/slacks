class ChannelCreated
  include VentSource::DomainEvent

  define_attributes :id, :name
end
