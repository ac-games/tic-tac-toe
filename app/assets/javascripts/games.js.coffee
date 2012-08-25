# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
    
ws = new WebSocket 'ws://localhost:8888'

ws.onmessage = (event) ->
    data = JSON.parse(event.data)
    if data.status == 'success'
        alert data.data
    else
        alert data.message

$("#create-new-game").live "click", (event) ->
    event.preventDefault()
    ws.send JSON.stringify({ 'action': 'game_creation' })
