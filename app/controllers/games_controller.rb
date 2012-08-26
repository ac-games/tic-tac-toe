# coding: utf-8

class GamesController < ApplicationController
  
  def index
    @games = Game.find_all_by_status(:created)
  end

  def show
    @game = Game.find(params[:id])
  end
  
  def create
    @game = Game.new
    if current_user.current_game.nil? && @game.save
      @game.users << current_user
    end
    get_games
  end
  
  def destroy
    @game = Game.find(params[:id])
    @game.delete
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
