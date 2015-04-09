class ChannelProjection < VentSource::Projection
  projection_name :channel

  class Channel < ActiveRecord::Base
    self.table_name = :channels

    def self.name_unique?(name)
      where(name: name).none?
    end
  end

  def channel_created(event)
    Channel.create!(aggregate_id: event.aggregate_id, name: event.data['name'])
  end
end
