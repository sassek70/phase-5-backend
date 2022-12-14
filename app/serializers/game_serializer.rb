class GameSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :opponent_id, :isActive
end
