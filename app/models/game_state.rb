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
  
  def who_won?
    field = self.game_field_as_matrix
    field.each { |row| return row.first if elems_eql? row }
    field.transpose.each { |col| return col.first if elems_eql? col }
    diagonal = { :main => [], :secondary => [] }
    3.times do |i|
      diagonal[:main] << field[i][i]
      diagonal[:secondary] << field[i][2 - i]
    end
    diagonal.values.each { |diag| return diag.first if elems_eql? diag }
    false
  end
  
  def put_the_symbol(symbol, position)
    i, j = parse_position(position)
    field = self.game_field_as_matrix
    return false unless field[i][j] == ' '
    field[i][j] = symbol
    self.update_attribute :game_field, field.join('|')
  end
  
  def game_field_as_matrix
    field = []
    flat_field = self.game_field.split '|'
    3.times do |i|
      field[i] = []
      flat_field[i*3..i*3+2].each_with_index do |elem, j|
        field[i][j] = elem
      end
    end
    field
  end
  
  def clear_game_field
    self.update_attribute :game_field, ([' ']*9).join('|')
  end
  
  protected
  
  def parse_position(position)
    [position['i'].to_i, position['j'].to_i]
  end
  
  def elems_eql?(elems)
    return false if elems.include? ' '
    elems.map { |elem| return false unless elem == elems.first }
    true
  end
end
