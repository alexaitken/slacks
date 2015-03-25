class Person
  include VentSource::AggregateRoot
  include BCrypt

  attr_reader :name, :display_name, :email_address, :password, :sign_ins

  def self.email_exists?(email_address)
    false
  end

  def self.find(id)
    VentSource::AggregateRoot.find(id, 'Person')
  end

  def signup(id:, name:, email_address:, password:)
    return false if Person.email_exists?(email_address)

    apply SignedUp.new(id: id, name: name, email_address: email_address, password_hash: Password.create(password).to_s)
    true
  end

  def sign_in(client:, auth_token:)
    apply SignedIn.new(client: client, auth_token: auth_token)
    true
  end

  def signed_up(event)
    @id = event.id
    @name = event.name
    @email_address = event.email_address
    self.password = event.password_hash
    self
  end

  def signed_in(event)
    @sign_ins ||= []
    @sign_ins << [event.auth_token, event.client]
    self
  end

  def password=(new_password)
    @password = Password.create(password)
  end
end
