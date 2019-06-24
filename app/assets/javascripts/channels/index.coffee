#= require action_cable
#= require_self
#= require_tree .

@App = {}
App.cable = ActionCable.createConsumer('http://localhost:25000/cable')

App.cable.subscriptions.create "ChatChannel",
  received: (data) ->
    $channel = $('#channel-' + data['channel_id'])
    if data['event'] == 'message_sent'
      $channel.find('.channel--messages').append(data['message_html'])
    if data['event'] == 'message_edited'
      $channel.find('.channel--messages #message-' + data['message_id']).replaceWith(data['message_html'])
    if data['event'] == 'joined'
      $channel.find('#channel--member-list').append('<li id="' + data['member_id'] + '">' + data['member_name'] + '</li>')
    if data['event'] == 'left'
      $channel.find('#channel--member-list #' + data['member_id']).remove()
    console.log(data)


$(document).ready ->
  $("#new_send_message").on("ajax:success", (e, data, status, xhr) ->
    $("#new_send_message").append xhr.responseText
  ).on("ajax:error", (e, xhr, status, error) ->
    $("#new_send_message").append "<p>ERROR</p>"
  ).on("ajax:success", (e, data, status, xhr) ->
    $("#new_send_message #send_message_message").val('')
  )
