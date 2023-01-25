class User < ApplicationRecord
    validates :username, uniqueness: true
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    has_many :user_cards
    has_many :cards, through: :user_cards
    has_many :games, through: :user_cards
    has_secure_password
    
end
