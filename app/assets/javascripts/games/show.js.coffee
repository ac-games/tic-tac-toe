$.app.games.show = () ->
    # vars
    $.extend @,
        'game_id':    $("#game-data").attr("data-game-id")
        'my_turn':    false
        'start_time': 300
    # events
    
    # actions
    @.reset_timer()
    setInterval @.time_step, @timer_interval

$.app.games.time_step = () ->
    if $.app.games.my_turn
        $.app.games.update_timer()
    else
        $.app.games.get_game_state()

$.app.games.reset_timer = () ->
    $("#game-timer").text(@start_time)

$.app.games.update_timer = () ->
    $timer = $("#game-timer")
    time = parseInt($timer.text())
    if time > 0
        $timer.text(time - 1)
    else
        alert "Время вышло!"

$.app.games.get_game_state = () ->
    $.ajax
        type: "POST"
        url: "/games/#{$.app.games.game_id}/get_game_state"
        success: (data) ->
            if data.status == 'success'
                $("#game-field").html data.html
                $.app.games.my_turn = true
