class PlayerAction < ApplicationRecord

    # has_one :user_card, as: :defending_card
    has_one :attacking_card, class_name: "UserCard", foreign_key: :attacking_card_id 
    has_one :defending_card, class_name: "UserCard", foreign_key: :defending_card_id 
    has_one :user_card, class_name: "User", foreign_key: :attacking_player_id
    has_one :user_card, class_name: "User", foreign_key: :defending_player_id

    belongs_to :game

end
