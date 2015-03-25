class Command::SignUp
  include ::VentSource::Command

  attr_accessor :name, :email_address, :password
  attr_reader :person_id

  validates :name, presence: true
  validates :email_address, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :password, presence: true, length: { minimum: 6 }


  def initialize(attr = {})
    super

    @person_id = generate_id
  end

  def execute(person)
    return false unless valid?

    #get error information here add to errors.
    person.signup(
      id: person_id,
      name: name,
      email_address: email_address,
      password: password
    )
  end
end
