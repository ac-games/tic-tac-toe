# coding: utf-8

class GamesController < ApplicationController
  
  def index
    @games = Game.find_all_by_status(:created)
  end

  def show
    @game = Game.find(params[:id])
    @game.users << current_user
    @game.update_attribute(:status, :started)
  end
  
  def create
    @game = Game.new
    @game_state = GameState.new
    if current_user.current_game.nil? && @game.save
      @game.users << current_user
      @game_state.game = @game
      @game_state.current_user = current_user
      @game.delete unless @game_state.save
    end
    get_games
  end
  
  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end
  
  def get_games
    respond_to do |format|
      format.html {
        render(:partial => 'game_items_list', :locals => {
          :games => Game.find_all_by_status(:created)
        })
      }
    end
  end
end
