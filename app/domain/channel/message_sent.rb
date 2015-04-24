class MessageSent
  include VentSource::DomainEvent

  define_attributes :person_id, :message
end
