class User < ApplicationRecord
    validates :username, uniqueness: true
    validates :password, presence: true, length: {minimum: 6}
    has_many :user_cards
    has_many :cards, through: :user_cards
    has_many :games, through: :user_cards
    # has_many :games, through: :player_actions
    has_secure_password
end
