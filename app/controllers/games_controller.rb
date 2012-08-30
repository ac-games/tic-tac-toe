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
    respond_to do |format|
      if @game.game_state.current_user == current_user
        format.json do
          render :json => {
            :status => :success,
            :html => render_to_string(
              :partial => 'game_field.html',
              :locals => {
                :game_state => @game.game_state
              })
          }
        end
      else
        format.json { render :json => { :status => :out_of_turn } }
      end
    end
  end
  
  def put_the_symbol
    @game = Game.find(params[:game_id])
    respond_to do |format|
      if @game.game_state.current_user == current_user
        symbol = @game.users.first == current_user ? 'X' : 'O'
        if @game.game_state.put_the_symbol(symbol, params[:position])
          @game.reload
          win_sym = @game.game_state.who_won?
          win_user = win_sym == 'X' ? current_user : current_user.opponent if win_sym
          unless win_user
            @game.game_state.update_attribute :current_user, current_user.opponent
            format.json do
              render :json => {
                :status => :success,
                :html => render_to_string(
                  :partial => 'game_field.html',
                  :locals => {
                    :game_state => @game.game_state
                  })
              }
            end
          else
            format.json { render :json => {
              :status => :game_is_over,
              :win_user => win_user.email,
              :html => render_to_string(
                :partial => 'game_field.html',
                :locals => {
                  :game_state => @game.game_state
                })
            } }
          end
        else
          format.json { render :json => { :status => :bad_position } }
        end
      else
        format.json { render :json => { :status => :out_of_turn } }
      end
    end
  end
end
