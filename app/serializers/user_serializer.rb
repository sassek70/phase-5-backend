class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :gamesPlayed, :gamesWon, :gamesLost
end
