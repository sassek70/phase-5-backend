class PlayerActionSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :winning_card_id, :destroyed_card_id, :both_destroyed, :draw, :unblocked_attack, :attacking_user_card
  # has_one :user_card, as: :defending_card
  # has_one :user_card, as: :attacking_card
  # has_one :user_card, as: :defending_player
  # has_one :user_card, as: :attacking_player
  # belongs_to :game


  has_many :player_action_cards
    # has_many :attacking_user_cards, through: :player_action_cards, class_name: "UserCard"
    # has_many :defending_user_cards, through: :player_action_cards, class_name: "UserCard"
  # has_many :user_cards, through: :player_action_cards
end
