# coding: utf-8

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
    ws_message = ActiveSupport::JSON.decode @ws_message
    case ws_message['action']
    when 'game_creation'
      @ws_client.send ws_response(game_creation)
    end
  end
  
  def game_creation
    @game = Game.new
    if @game.save
      @game.users << current_user
      { :action => :game_creation,
        :data => render_to_string({
          :partial => 'game_info',
          :locals => { :game => @game }
      }) }
    else
      { :status => :error, :message => 'Ошибка: Не удалось создать новую игру' }
    end
  end
end
