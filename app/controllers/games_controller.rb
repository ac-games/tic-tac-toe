class GamesController < ApplicationController
  before_filter :web_socket_stop
  before_filter :web_socket_start, :only => :index
  
  def index
    @games = Game.find_all_by_status(:created)
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
    @ws_client.send "GamesController: #{@ws_message}"
  end
end
