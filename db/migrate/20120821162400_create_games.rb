class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_win_id
      t.string :status, :null => false, :default => :created

      t.timestamps
    end
  end
end
