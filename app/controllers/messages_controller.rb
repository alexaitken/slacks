class MessagesController < ApplicationController
  def create
    channel = ChannelProjection::Channel.find_by(name: params[:channel_name])

    channel_root = Channel.find(channel.aggregate_id)

    command = SendMessage.new message_params.merge(
      person_id: current_user.id
    )

    if command.execute(channel_root) && channel_root.commit
      redirect_to channel_path(channel.name)
    else
      byebug
      redirect_to channel_path(channel.name), error: "Message not sent"
    end
  end

  private

  def message_params
    params.require(:send_message).permit(:message)
  end
end