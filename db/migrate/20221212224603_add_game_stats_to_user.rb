class AddGameStatsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gamesPlayed, :integer
    add_column :users, :gamesWon, :integer
    add_column :users, :gamesLost, :integer
    add_column :users, :win_rate, :float, default: 0.00
  end
end
