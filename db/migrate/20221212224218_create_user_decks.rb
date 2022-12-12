class CreateUserDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_decks do |t|
      t.integer :user_id
      t.integer :card_id

      t.timestamps
    end
  end
end
