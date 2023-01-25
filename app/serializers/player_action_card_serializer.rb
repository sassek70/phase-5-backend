class PlayerActionCardSerializer < ActiveModel::Serializer
  attributes :id, :user_card, :player_action
  belongs_to :user_card
  belongs_to :player_action

end
