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
  
  TIME_TO_TURN = 30
  
  # Получить пользователя, который сейчас ходит
  def current_user
    self.user
  end
  
  # Задать пользователя, который сейчас ходит
  def current_user=(user)
    self.user = user
  end
  
  def pass_the_turn
    self.update_attribute :current_user, self.current_user.opponent
  end
  
  def remaining_time
    if self.timer_updated_at.nil?
      self.update_attribute :timer_updated_at, Time.now
    end
    bygone_time = (Time.now - self.timer_updated_at).seconds.to_i
    return bygone_time < TIME_TO_TURN ? TIME_TO_TURN - bygone_time : 0
  end
  
  # Возвращает победившего пользователя или false, если игра ещё не закончена
  def who_won?
    won_sym = self.won_symbol
    if won_sym
      game_current_user = self.game.main_user
      won_sym == 'X' ? game_current_user : game_current_user.opponent
    else
      false
    end
  end
  
  # По игровому полю определяет кто победил, крестики или нолики
  # Возвращает false, если игра ещё не закончена
  def won_symbol
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
  
  # Ставит соответствующий символ (X или O) в нужную клетку и сохраняет в базе
  def put_the_symbol(symbol, position)
    i, j = parse_position(position)
    field = self.game_field_as_matrix
    return false unless field[i][j] == ' '
    field[i][j] = symbol
    self.update_attribute :game_field, field.join('|')
  end
  
  # Возвращает игровое поле в виде двумерного массива
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
  
  # Корректно очищает в базе игровое поле
  def clear_game_field
    self.update_attribute :game_field, ([' ']*9).join('|')
  end
  
  protected
  
  # Вычленяет из приходящих параметров координаты клетки поля
  def parse_position(position)
    [position['i'].to_i, position['j'].to_i]
  end
  
  # Возвращает true, если все элементы массива попарно равны, иначе - false
  def elems_eql?(elems)
    return false if elems.include? ' '
    elems.map { |elem| return false unless elem == elems.first }
    true
  end
end
