class UserCard < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :player_action, optional: true
    belongs_to :card
    belongs_to :game
end
