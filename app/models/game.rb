class Game < ApplicationRecord
    # has_secure_token
    has_secure_token :game_key, length: 36
    # generates_token_for :game_key
end
