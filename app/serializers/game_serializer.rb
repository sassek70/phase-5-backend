class GameSerializer < ActiveModel::Serializer
  attributes :id, :host_user_id, :opponent_id, :game_key
end
