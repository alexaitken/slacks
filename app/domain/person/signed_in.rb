class SignedIn
  include VentSource::DomainEvent

  define_attributes :auth_token, :client
end
