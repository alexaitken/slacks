class Channel
  include VentSource::AggregateRoot

  def create(id:, name:)
    return false unless ChannelProjection::Channel.name_unique?(name)

    apply ::ChannelCreated.new(id: id, name: name)
    true
  end

  def join(person_id:)
    unless @members.include?(person_id)
      apply ::JoinedChannel.new(person_id: person_id)
    end

    true
  end

  def leave(person_id:)
    if @members.include?(person_id)
      apply ::LeftChannel.new(person_id: person_id)
    end

    true
  end

  def create_message(person_id:, message:, message_id:)
    return false unless @members.include?(person_id)
    return false if @message_ids.include?(message_id)

    apply ::MessageSent.new(message_id: message_id, person_id: person_id, message: message)
    true
  end

  private

  def channel_created(event)
    @id = event.id
    @name = event.name
    @members = []
    @message_ids = []
  end

  def joined_channel(event)
    @members << event.person_id
  end

  def left_channel(event)
    @members.delete(event.person_id)
  end

  def message_sent(event)
    @message_ids << event.message_id
  end
end
