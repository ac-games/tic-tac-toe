class GamesController < ApplicationController
  def index
    @games = Game.find_all_by_status(:created)
    web_socket_start
  end

  def show
    @game = Game.find(params[:id])
    session[:in_game] = @game.id
  end
  
  def destroy
    session[:in_game] = false
    redirect_to games_path
  end
  
  protected
  
  def ws_onmessage
    @ws.send "Games controller: #{@message}"
  end
end
