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
    if data['event'] == 'joined'
      $channel.find('.channel--member-list').append('<li>' + data['member_name'] + '</li>')


$(document).ready ->
  $("#new_send_message").on("ajax:success", (e, data, status, xhr) ->
    $("#new_send_message").append xhr.responseText
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#new_send_message").append "<p>ERROR</p>"

