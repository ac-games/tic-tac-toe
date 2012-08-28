# == Schema Information
#
# Table name: game_states
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  current_user_id :integer
#  game_field      :string(255)
#

class GameState < ActiveRecord::Base
  attr_accessible
  
  belongs_to :game
  belongs_to :user, :foreign_key => :current_user_id
  
  def current_user
    self.user
  end
  
  def current_user=(user)
    self.user = user
  end
end
