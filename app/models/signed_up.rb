class SignedUp
  include VentSource::DomainEvent

  define_attributes :id, :name, :email_address, :password_hash
end
