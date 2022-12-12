class GameSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :winning_player_id
end
