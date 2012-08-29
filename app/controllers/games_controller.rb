# coding: utf-8

class GamesController < ApplicationController
  
  def index
    @games = Game.find_all_by_status(:created)
  end

  def show
    @game = Game.find(params[:id])
    @game.users << current_user
    @game.update_attribute(:status, :started)
    
    @game_state = @game.game_state
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
  
  def get_game_state
    @game = Game.find(params[:game_id])
    @game_state = @game.game_state
    respond_to do |format|
      if @game_state.current_user == current_user
        format.json do
          render :json => {
            :status => :success,
            :html => render_to_string(
              :partial => 'game_field.html',
              :locals => {
                :game_state => @game_state
              })
          }
        end
      else
        format.json { render :json => { :status => :out_of_turn } }
      end
    end
  end
end
