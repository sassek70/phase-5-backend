class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :cardName
      t.integer :cardPower
      t.integer :cardDefense
      t.string :cardDescription
      t.integer :cardCost

      t.timestamps
    end
  end
end
