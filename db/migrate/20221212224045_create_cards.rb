class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :cardName
      t.integer :cardPower
      t.integer :cardDefense
      t.string :cardDescription
      t.integer :cardCost
      t.string :artist
      t.string :image
      t.integer :mtgo_id

      t.timestamps
    end
  end
end
