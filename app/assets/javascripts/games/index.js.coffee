$.app.games.index = () ->
    # events
    $("#create-new-game").live "click", $.app.games.create_new_game
    # actions
    setInterval $.app.games.get_games, $.app.games.interval

$.app.games.update_game_items_list = (html) ->
    $("#game-items-list-wrapper").html html

$.app.games.create_new_game = (event) ->
    event.preventDefault()
    $.ajax
        type: "POST"
        url: "/games"
        success: (html) ->
            $.app.games.update_game_items_list html

$.app.games.get_games = () ->
    $.ajax
        type: "GET"
        url: "games/get_games"
        success: (html) ->
            $.app.games.update_game_items_list html
