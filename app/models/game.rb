# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  user_win_id :integer
#  status      :string(255)      default("created"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Game < ActiveRecord::Base
  attr_accessible
  
  has_and_belongs_to_many :users
end
