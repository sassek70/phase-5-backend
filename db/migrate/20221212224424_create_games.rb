class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :host_user_id
      t.integer :opponent_id
      t.string :game_key
      # t.boolean :isActive
      t.integer :winning_player_id

      t.timestamps
    end
  end
end
