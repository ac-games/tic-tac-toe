$("#create-new-game").live "click", (event) ->
    event.preventDefault()
    $.ajax
        type: "POST"
        url: "/games"
        success: (data) ->
            if (data != 'error')
                $("#game-items-list").append data
