class MembersController < ApplicationController
  def create
    channel = ChannelProjection::Channel.find_by(name: params[:channel_name])

    channel_root = Channel.find(channel.aggregate_id)

    command = JoinChannel.new user_id: current_user.id

    if command.execute(channel_root) && channel_root.commit
      redirect_to channel_path(channel.name)
    else
      redirect_to channel_path(channel.name), error: "could not sent join"
    end
  end
end
