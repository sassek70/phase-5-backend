class RemoveGamesLostColumnFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :gamesLost, :integer
  end
end
