class Game < ActiveRecord::Base
  attr_accessible
  
  has_and_belongs_to_many :users
end
