# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#create-new-game").live "click", (event) ->
    event.preventDefault()
    $.ajax
        type: "POST"
        url: "/games"
        success: (data) ->
            if (data != 'error')
                $("#games_list").append data
