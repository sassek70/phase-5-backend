class User < ApplicationRecord
    validates :username, uniqueness: true
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    # validates :password, presence: true, length: {minimum: 6}
    # validates :password, length: {minimum: 6}, :if => :validate_password?
    has_many :user_cards
    has_many :cards, through: :user_cards
    has_many :games, through: :user_cards
    # has_many :games, through: :player_actions
    has_secure_password



    # def validate_password?
    #     password.present? || password_confirmation.present?
    # end

end
