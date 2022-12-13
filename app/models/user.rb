class User < ApplicationRecord
    validates :username, uniqueness: true
    validates :password, presence: true, length: {minimum: 6}
    has_secure_password
end
