class AddHealthToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :host_player_health, :integer, default: 20
    add_column :games, :opponent_player_health, :integer, default: 20
  end
end
