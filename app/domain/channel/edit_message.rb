class EditMessage
  include VentSource::Command

  attr_accessor :message, :person_id, :message_id

  validates :message, presence: true, allow_blank: false

  validates :person_id, presence: true

  validates :message_id, presence: true, uuid: true

  def execute(channel)
    return false unless valid?

    channel.edit_message(message_id: message_id, person_id: person_id, new_message: message)
  end
end
