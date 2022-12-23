class UserCardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :card_id, :game_id, :isActive
  # belongs_to :user, optional: true
  # belongs_to :player_action, optional: true
  # belongs_to :card
  # belongs_to :game


  belongs_to :user, optional: true
  belongs_to :card
  belongs_to :game


  has_many :player_action_cards
  has_many :player_actions, through: :player_action_cards
end
