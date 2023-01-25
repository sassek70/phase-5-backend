class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :gamesPlayed, :gamesWon, :win_rate
  
end
