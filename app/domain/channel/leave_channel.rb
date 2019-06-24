class LeaveChannel
  include VentSource::Command

  attr_accessor :user_id

  validates :user_id, presence: true

  def execute(channel)
    return false unless valid?

    channel.leave(person_id: user_id)
  end
end
