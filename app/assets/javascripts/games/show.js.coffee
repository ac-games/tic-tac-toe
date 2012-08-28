$.app.games.show = () ->
    # vars
    $.app.games.game_id = $("#game-data").attr("data-game-id")
    # events
    
    # actions
    $.app.games.get_game_state()
    
$.app.games.get_game_state = () ->
    $.ajax
        type: "POST"
        url: "/games/#{$.app.games.game_id}/get_game_state"
        success: (data) ->
            alert data.html
