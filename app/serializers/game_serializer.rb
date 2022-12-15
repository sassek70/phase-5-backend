class GameSerializer < ActiveModel::Serializer
  attributes :id, :host_user_id, :opponent_id, :isActive, :game_key
end
