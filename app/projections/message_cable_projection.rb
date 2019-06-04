class MessageCableProjection < VentSource::Projection

  projection_name 'message_cable'

  def self.reset_projection_records
  end

  def joined_channel(event)
    person = Login.find_by(aggregate_id: event.data['person_id'])

    ActionCable.server.broadcast("chat_messages",
      event: 'joined',
      channel_id: event.aggregate_id,
      member_name: person.name
    )
  end

  def message_sent(event)
    channel = ChannelProjection::Channel.find_by(aggregate_id: event.aggregate_id)
    member = channel.members.find_by(person_id: event.data['person_id'])
    message = channel.messages.build(message: event.data['message'], member_id: member.id)

    ActionCable.server.broadcast("chat_messages",
      event: 'message_sent',
      channel_id: event.aggregate_id,
      member_name: member.name,
      message: event.data['message'],
      message_html: ApplicationController.renderer.render(
        partial: 'channels/message',
        locals: {
          message: message
        }
      )
    )
  end
end
