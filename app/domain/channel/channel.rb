class Channel
  include VentSource::AggregateRoot

  def create(id:, name:)
    return false unless ChannelProjection::Channel.name_unique?(name)

    apply ChannelCreated.new(id: id, name: name)
    true
  end

  private

  def channel_created(event)
    @id = event.id
    @name = event.name
  end
end
