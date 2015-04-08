class SignOut
  include ::VentSource::Command

  attr_accessor :auth_token

  validates :auth_token, presence: true, length: { minimum: 10 }

  def initialize(attr = {})
    super
  end

  def execute(person)
    return false unless valid?
    person.sign_out(auth_token: auth_token)
  end
end
