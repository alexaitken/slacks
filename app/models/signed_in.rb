class SignedIn
  include VentSource::Event

  define_attributes :auth_token, :client
end
