module ChannelsHelper
  def member_of?(channel)
    channel.members.where(person_id: current_user.id).exists?
  end
end
