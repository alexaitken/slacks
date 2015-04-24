class Channel
  include VentSource::AggregateRoot

  def create(id:, name:)
    return false unless ChannelProjection.name_unique?(name)

    apply ::ChannelCreated.new(id: id, name: name)
    true
  end

  def join(person_id:)
    apply ::Joined.new(person_id: person_id)
    true
  end

  def create_message(person_id:, message:)
    return false if @members.include?(person_id)

    apply ::MessageSent.new(person_id: person_id, message: message)
    true
  end

  private

  def channel_created(event)
    @id = event.id
    @name = event.name
    @members = []
  end

  def joined(event)
    @members << event.person_id
  end

  def message_sent(event)
  end
end
