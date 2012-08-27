class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :game_id
      t.integer :current_user_id
      t.string :game_field, :default => " | | | | | | | | "
    end
  end
end
