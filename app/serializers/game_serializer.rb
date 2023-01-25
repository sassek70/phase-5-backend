class GameSerializer < ActiveModel::Serializer
  attributes :id, :host_user_id, :opponent_id, :game_key, :host_player_health, :opponent_player_health, :winning_player_id
  
end
