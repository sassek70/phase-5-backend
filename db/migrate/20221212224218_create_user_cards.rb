class CreateUserCards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cards do |t|
      t.integer :user_id
      t.integer :card_id

      t.timestamps
    end
  end
end
