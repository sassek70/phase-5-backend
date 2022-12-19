class CreatePlayerActions < ActiveRecord::Migration[7.0]
  def change
    create_table :player_actions do |t|
      t.integer :player_id
      t.integer :target_player_id
      t.integer :card_id
      t.string :game_id
      t.integer :action_id


      t.timestamps
    end
  end
end
