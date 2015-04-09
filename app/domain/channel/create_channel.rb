class CreateChannel
  include VentSource::Command

  attr_accessor :name
  attr_reader :channel_id

  validates :name, presence: true
  validate :name, :name_is_unique

  def initialize(attr = {})
    super

    @channel_id = generate_id
  end

  def execute(channel)
    return false unless valid?

    #get error information here add to errors.
    channel.create(
      id: channel_id,
      name: name,
    )
  end

  private

  def name_is_unique

    ChannelProjection::Channel.name_unique?(name)
  end

end
