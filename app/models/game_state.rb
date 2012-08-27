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
end
