class MessagesController < ApplicationController
  def create
    channel = ChannelProjection::Channel.find_by(name: params[:channel_name])

    channel_root = Channel.find(channel.aggregate_id)

    command = SendMessage.new message_params.merge(
      person_id: current_user.id,
      message_id: SecureRandom.uuid,
    )

    if command.execute(channel_root) && channel_root.commit
      if request.xhr?
        head :created
      else
        redirect_to channel_path(channel.name)
      end
    else
      if request.xhr?
        head :unprocessable_entity
      else
        redirect_to channel_path(channel.name), error: "Message not sent"
      end
    end
  end

  def edit
    @channel = ChannelProjection::Channel.find_by(name: params[:channel_name])
    message = @channel.messages.find_by!(message_id: params[:id])
    @edit_command = EditMessage.new(message_id: message.message_id, message: message.message)
  end

  def update
    @channel = ChannelProjection::Channel.find_by(name: params[:channel_name])

    channel_root = Channel.find(@channel.aggregate_id)

    @edit_command = EditMessage.new(
      edit_message_params.merge(
        person_id: current_user.id,
        message_id: params[:id],
      )
    )

    if @edit_command.execute(channel_root) && channel_root.commit
      redirect_to channel_path(@channel.name)
    else
      render :edit
    end
  end

  private

  def message_params
    params.require(:send_message).permit(:message)
  end

  def edit_message_params
    params.require(:edit_message).permit(:message)
  end
end
