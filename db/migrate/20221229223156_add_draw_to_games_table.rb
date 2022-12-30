class AddDrawToGamesTable < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :draw, :boolean, default: false
  end
end
