class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :game_id
      t.integer :winning_player_id

      t.timestamps
    end
  end
end
