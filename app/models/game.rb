class Game < ApplicationRecord
    has_many :user_cards
    has_many :users, through: :user_cards
    has_secure_token :game_key, length: 36

end
