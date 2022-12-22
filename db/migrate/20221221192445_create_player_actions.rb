class CreatePlayerActions < ActiveRecord::Migration[7.0]
  def change
    create_table :player_actions do |t|
      t.integer :attacking_player_id
      t.integer :attacking_card_id
      t.integer :defending_player_id
      t.integer :defending_card_id
      t.integer :game_id
      t.integer :winning_card_id
      t.integer :destroyed_card_id
      t.boolean :both_destroyed, default: false
      t.boolean :draw, default: false
      t.boolean :unblocked_damage, default: false

      t.timestamps
    end
  end
end
