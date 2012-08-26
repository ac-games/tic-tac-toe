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
    respond_to do |format|
      if current_user.may_create_game? && @game.save
        @game.users << current_user
        format.html {
          render(:partial => 'game_item', :locals => {
            :game => @game
          })
        }
      else
        format.js { render(:js => 'error') }
      end
    end
  end
  
  def destroy
    session[:in_game] = false
    redirect_to games_path
  end
end
