class Channel
  include VentSource::AggregateRoot

  def create(id:, name:)
    return false unless ChannelProjection.name_unique?(name)

    apply ChannelCreated.new(id: id, name: name)
    true
  end
end
