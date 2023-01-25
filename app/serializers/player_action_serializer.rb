class PlayerActionSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :winning_card_id, :destroyed_card_id, :both_destroyed, :draw, :unblocked_attack, :attacking_user_card

  has_many :player_action_cards
end
