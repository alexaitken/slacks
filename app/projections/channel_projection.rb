class ChannelProjection < VentSource::Projection
  projection_name :channel

  def self.reset_projection_records
    Channel.delete_all
    Member.delete_all
    Message.delete_all
  end

  class Channel < ActiveRecord::Base
    self.table_name = :channels
    has_many :members
    has_many :messages

    def self.name_unique?(name)
      where(name: name).none?
    end

    def member?(person_id)
      members.find_by(aggregate_id: person_id)
    end
  end

  class Member < ActiveRecord::Base
    self.table_name = :members

    belongs_to :channel
  end

  class Message < ActiveRecord::Base
    self.table_name = :messages

    belongs_to :channel
    belongs_to :member
  end


  def channel_created(event)
    Channel.create!(aggregate_id: event.aggregate_id, name: event.data['name'])
  end

  def joined_channel(event)

    channel = Channel.find(aggregate_id: event.aggregate_id)
    person = Login.find(event.data['person_id'])

    channel.members.create!(person_id: person.aggregate_id, name: person.name)
  end

  def message_sent(event)
    puts "Hell yeah: #{event.data['message']}"
  end
end
