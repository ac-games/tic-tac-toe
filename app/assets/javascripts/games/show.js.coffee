$.app.games.show = () ->
    # vars
    $.extend @,
        'game_id':    $("#game-data").attr("data-game-id")
        'my_turn':    false
        'start_time': 30
    # events
    $("#field-table td").live "click", @.put_the_symbol
    # actions
    @.reset_timer()
    setInterval @.time_step, @timer_interval

$.app.games.put_the_symbol = () ->
    if $.app.games.my_turn
        $.ajax
            type: "POST"
            data:
                position: $(@).data()
            url: "#{$.app.games.game_id}/put_the_symbol"
            success: (data) ->
                if data.status == 'success'
                    $("#game-field").html data.html
                    $.app.games.my_turn = false
                    $.app.games.reset_timer()
                if data.status == 'game_is_over'
                    $("#game-field").html data.html
                    alert "Победил #{data.win_user}"

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
        $timer.text("Время вышло!")

$.app.games.get_game_state = () ->
    $.ajax
        type: "POST"
        url: "/games/#{$.app.games.game_id}/get_game_state"
        success: (data) ->
            if data.status == 'success'
                $("#game-field").html data.html
                $.app.games.my_turn = true
                $.app.games.reset_timer()
