class GamesController < ApplicationController
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
end
