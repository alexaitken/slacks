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
    return false if @messages.find { |message| message.message_id == message_id }

    apply ::MessageSent.new(message_id: message_id, person_id: person_id, message: message)
    true
  end

  def edit_message(new_message:, message_id:, person_id:)
    message = @messages.find { |message| message.message_id = message_id }
    return false unless message
    return false unless message.posted_by?(person_id)

    apply ::MessageEdited.new(message_id: message_id, updated_message: new_message)
  end

  private

  def channel_created(event)
    @id = event.id
    @name = event.name
    @members = []
    @messages = []
  end

  def joined_channel(event)
    @members << event.person_id
  end

  def left_channel(event)
    @members.delete(event.person_id)
  end

  def message_sent(event)
    @messages << Message.new(event.message_id, event.person_id)
  end

  def message_edited(event)
  end

  Message = Struct.new(:message_id, :person_id) do
    def posted_by?(this_person)
      this_person == person_id
    end
  end
end
