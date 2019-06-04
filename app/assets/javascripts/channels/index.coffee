#= require action_cable
#= require_self
#= require_tree .

@App = {}
App.cable = ActionCable.createConsumer('http://localhost:25000/cable')

App.cable.subscriptions.create "ChatChannel",
  received: (data) ->
    if data['event'] == 'message_sent'
      $('.channel--messages').append(data['message_html'])

$(document).ready ->
  $("#new_send_message").on("ajax:success", (e, data, status, xhr) ->
    $("#new_send_message").append xhr.responseText
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#new_send_message").append "<p>ERROR</p>"

