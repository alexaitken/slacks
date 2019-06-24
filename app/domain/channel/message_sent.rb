class MessageSent
  include VentSource::DomainEvent

  define_attributes :person_id, :message, :message_id
end
