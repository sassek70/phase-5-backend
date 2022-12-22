class CreatePlayerActionCards < ActiveRecord::Migration[7.0]
  def change
    create_table :player_action_cards do |t|
      t.integer :user_card_id
      t.integer :player_action_id
      t.boolean :is_attacking

      t.timestamps
    end
  end
end
