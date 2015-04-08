class SignIn
  include ::VentSource::Command

  attr_accessor :client, :auth_token, :password

  validates :auth_token, presence: true, length: { minimum: 10 }
  validates :client, presence: true
  validates :password, presence: true

  def initialize(attr = {})
    super
  end

  def execute(person)
    return false unless valid?
    person.sign_in(client: client, auth_token: auth_token, given_password: password)
  end
end
