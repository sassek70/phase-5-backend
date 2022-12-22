class UserCard < ApplicationRecord
    # belongs_to :player_action, optional: true
    belongs_to :user, optional: true
    belongs_to :card
    belongs_to :game


    has_many :player_action_cards
    has_many :player_actions, through: :player_action_cards


end
