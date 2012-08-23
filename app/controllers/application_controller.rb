class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :staying_in_the_game
  
  protected
  
  def staying_in_the_game
    game_id = session[:in_game]
    if game_id && request.path != game_path(game_id)
      redirect_to game_path(game_id)
    end
  end
  
  def web_socket_start
    Thread.new do
      EventMachine.run {
        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
          ws.onopen { ws_onopen(ws) }
          ws.onmessage { |data| ws_onmessage(ws, data) }
          ws.onclose { ws_onclose }
        end
      }
    end
  end
  
  def ws_onopen(ws)
    # Ничего не делать
  end
  
  def ws_onmessage(ws, data)
    ws.send "ApplicationController: #{data}"
  end
  
  def ws_onclose(ws)
    # Ничего не делать
  end
end
