module GamesHelper
  def opponent_user
    current_user.opponent
  end
end
