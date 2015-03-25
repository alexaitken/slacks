class SignedUp
  include VentSource::Event

  define_attributes :id, :name, :email_address, :password_hash
end
