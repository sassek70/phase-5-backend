class UserCardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :card_id, :game_id
  belongs_to :user, optional: true
  belongs_to :player_action, optional: true
  belongs_to :card
  belongs_to :game
end
