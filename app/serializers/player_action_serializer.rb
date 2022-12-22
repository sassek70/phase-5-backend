class PlayerActionSerializer < ActiveModel::Serializer
  attributes :id, :attacking_player_id, :attacking_card_id, :defending_player_id, :game_id, :winning_card_id, :destroyed_card_id, :both_destroyed, :draw, :unblocked_attack
  has_one :user_card, as: :defending_card
  has_one :user_card, as: :attacking_card
  has_one :user_card, as: :defending_player
  has_one :user_card, as: :attacking_player
  belongs_to :game
end
