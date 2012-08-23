# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
    
ws = new WebSocket 'ws://localhost:8080'

ws.onmessage = (event) ->
    alert event.data

$("#test").live "click", (event) ->
    event.preventDefault()
    ws.send 'Message from client'
