class SignedOut
  include VentSource::DomainEvent

  define_attributes :auth_token, :client
end
