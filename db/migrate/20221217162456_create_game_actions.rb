class CreateGameActions < ActiveRecord::Migration[7.0]
  def change
    create_table :game_actions do |t|
      t.integer :count
      t.string :game_key

      t.timestamps
    end
  end
end
