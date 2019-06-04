App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    console.log('connected')
    # Called when the subscription is ready for use on the server

  disconnected: ->
    console.log('disconnected')
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log(data)
