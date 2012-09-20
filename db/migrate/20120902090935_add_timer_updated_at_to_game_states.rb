class AddTimerUpdatedAtToGameStates < ActiveRecord::Migration
  def change
    add_column :game_states, :timer_updated_at, :datetime
  end
end
