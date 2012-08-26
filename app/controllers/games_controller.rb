# coding: utf-8

class GamesController < ApplicationController
  
  def index
    @games = Game.find_all_by_status(:created)
  end

  def show
    @game = Game.find(params[:id])
    session[:in_game] = @game.id
  end
  
  def create
    @game = Game.new
    if current_user.may_create_game? && @game.save
      @game.users << current_user
    end
    get_games
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
