class UserGameSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :opponent_id, :game_id, :isActive
end
