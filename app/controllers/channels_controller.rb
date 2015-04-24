class ChannelsController < ApplicationController
  def index
    @channels = ChannelProjection::Channel.all
  end

  def new
    @create_channel = CreateChannel.new
  end

  def create
    @create_channel = CreateChannel.new create_channel_params

    if @create_channel.valid?
      c = Channel.new
      if @create_channel.execute(c) && c.commit
        @join = JoinChannel.new user_id: current_user.id
        @join.execute(c) && c.commit
        redirect_to channel_path(create_channel.name)
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def show
    @channel = ChannelProjection::Channel.find_by name: params[:name]
  end

  private

  def create_channel_params
    params.require(:create_channel).permit(:name)
  end
end
