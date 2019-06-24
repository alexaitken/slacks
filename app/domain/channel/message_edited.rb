class MessageEdited
  include VentSource::DomainEvent

  define_attributes :updated_message, :message_id
end
