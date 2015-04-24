class SendMessage
  include VentSource::Command

  attr_accessor :message, :person_id

  validates :message, presence: true, allow_blank: false

  validates :person_id, presence: true

  def execute(channel)
    return false unless valid?

    channel.create_message(person_id: person_id, message: message)
  end

end
