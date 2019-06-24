class ChannelProjection < VentSource::Projection
  projection_name :channel

  def self.reset_projection_records
    Channel.delete_all
    Member.delete_all
    Message.delete_all
  end

  class Channel < ApplicationRecord
    self.table_name = :channels

    has_many :members, -> { active_members }, class_name: 'Member'
    has_many :messages

    def self.name_unique?(name)
      where(name: name).none?
    end

    def member?(person_id)
      members.find_by(aggregate_id: person_id)
    end
  end

  class Member < ApplicationRecord
    self.table_name = :members

    scope :active_members, -> { where(active: true) }

    belongs_to :channel
  end

  class Message < ApplicationRecord
    self.table_name = :messages

    belongs_to :channel
    belongs_to :member
  end

  def channel_created(event)
    Channel.create!(aggregate_id: event.aggregate_id, name: event.data['name'])
  end

  def joined_channel(event)
    channel = Channel.find_by(aggregate_id: event.aggregate_id)
    person = Login.find_by(aggregate_id: event.data['person_id'])

    channel.members.create!(person_id: person.aggregate_id, name: person.name, active: true)
  end

  def left_channel(event)
    channel = Channel.find_by(aggregate_id: event.aggregate_id)
    person = Login.find_by(aggregate_id: event.data['person_id'])

    channel.members.where(person_id: person.aggregate_id).update_all(active: false)
  end

  def message_sent(event)
    channel = Channel.find_by(aggregate_id: event.aggregate_id)
    member = channel.members.find_by(person_id: event.data['person_id'])

    channel.messages.create!(message: event.data['message'], member_id: member.id, message_id: event.data['message_id'])
  end

  def message_edited(event)
    channel = Channel.find_by(aggregate_id: event.aggregate_id)
    channel.messages.where(message_id: event.data['message_id']).update_all(message: event.data['updated_message'])
  end
end
