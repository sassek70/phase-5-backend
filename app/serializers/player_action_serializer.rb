class PlayerActionSerializer < ActiveModel::Serializer
  attributes :id, :attacking_player_id, :attacking_card_id, :defending_player_id, :game_id, :winning_card_id, :destroyed_card_id, :both_destroyed, :draw, :unblocked_attack
  belongs_to :user_card
  belongs_to :game
end
