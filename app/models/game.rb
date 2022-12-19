class Game < ApplicationRecord
    has_many :game_actions
    has_many :users, through: :game_actions
    has_secure_token :game_key, length: 36

end
