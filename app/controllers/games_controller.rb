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
    
    @time = @game_state.remaining_time
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
      success_json_render format,
        :partial => 'game_items_list.html',
        :locals => { :games => Game.find_all_by_status(:created) }
    end
  end
  
  def get_game_state
    @game = Game.find(params[:game_id])
    respond_to do |format|
      if @game.game_state.current_user == current_user
        success_json_render format,
          :partial => 'game_field.html',
          :locals => { :game_state => @game.game_state }
      else
        format.json { render :json => { :status => :waiting } }
      end
    end
  end
  
  def put_the_symbol
    @game = Game.find(params[:game_id])
    @game_state = @game.game_state
    respond_to do |format|
      if @game_state.current_user == current_user
        if @game_state.remaining_time == 0
          format.json { render :json => {
            :status => :time_is_up,
            :win_user => current_user.opponent.email
          } }
        end
        symbol = @game.main_user == current_user ? 'X' : 'O'
        if @game_state.put_the_symbol(symbol, params[:position])
          win_user = @game_state.who_won?
          if win_user
            options = { :status => :game_is_over, :win_user => win_user.email }
          else
            @game_state.pass_the_turn
            options = { }
          end
          success_json_render format, {
            :partial => 'game_field.html',
            :locals => { :game_state => @game_state }
          }.merge(options)
        else
          format.json { render :json => { :status => :bad_position } }
        end
      else
        format.json { render :json => { :status => :out_of_turn } }
      end
    end
  end
  
  private
  
  def success_json_render(format, options)
    json = {
      :status => :success,
      :html => render_to_string(
          :partial => options[:partial],
          :locals => options[:locals]
      )
    }
    options.delete :partial
    options.delete :locals
    json.merge!(options)
    format.json { render :json => json }
  end
end
