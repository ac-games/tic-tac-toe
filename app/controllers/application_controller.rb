class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :staying_in_the_game
  
  def staying_in_the_game
    game_id = session[:in_game]
    if game_id && request.path != game_path(game_id)
      redirect_to game_path(game_id)
    end
  end
end
