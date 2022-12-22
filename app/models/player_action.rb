class PlayerAction < ApplicationRecord

    belongs_to :user_card
    belongs_to :game

end
