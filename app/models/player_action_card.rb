class PlayerActionCard < ApplicationRecord
    belongs_to :user_card
    belongs_to :player_action
    
end
