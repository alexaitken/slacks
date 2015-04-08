class Person
  include VentSource::AggregateRoot
  include BCrypt

  attr_reader :name, :display_name, :email_address, :password, :sign_ins

  def signup(id:, name:, email_address:, password:)
    return false unless Login.email_unique?(email_address)

    apply SignedUp.new(id: id, name: name, email_address: email_address, password_hash: Password.create(password).to_s)
    true
  end

  def sign_in(client:, auth_token:, given_password:)
    return false if password != given_password

    apply SignedIn.new(client: client, auth_token: auth_token)
    true
  end

  def sign_out(auth_token:)
    if sign_ins.detect { |sign_in| sign_in.first == auth_token }
      apply SignedOut.new(auth_token: auth_token)
    end
    true
  end

  private

  def signed_up(event)
    @id = event.id
    @name = event.name
    @email_address = event.email_address
    self.password = event.password_hash
  end

  def signed_in(event)
    @sign_ins ||= []
    @sign_ins << [event.auth_token, event.client]
  end

  def signed_out(event)
    @sign_ins = @sign_ins.reject { |sign_in| sign_in.first == event.auth_token }
  end

  def password=(password_hash)
    @password = Password.new(password_hash)
  end
end
