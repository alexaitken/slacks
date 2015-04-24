class JoinChannel
  include VentSource::Command

  attr_accessor :user_id

  validates :user_id, presence: true

  def execute(channel)
    return false unless valid?

    channel.join(person_id: person_id)
  end
end
