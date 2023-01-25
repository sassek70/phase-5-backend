class CardSerializer < ActiveModel::Serializer
  attributes :id, :cardName, :cardPower, :cardDefense, :cardDescription, :cardCost, :cardImage, :mtgo_id, :cardArtist
  
end

