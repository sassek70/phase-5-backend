class Game < ApplicationRecord
    has_many :player_actions
    has_many :users, through: :player_actions
    has_secure_token :game_key, length: 36

end
