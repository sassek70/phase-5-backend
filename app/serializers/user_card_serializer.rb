class UserCardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :card_id, :game_id
  belongs_to :card
end
