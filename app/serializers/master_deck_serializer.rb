class MasterDeckSerializer < ActiveModel::Serializer
  attributes :id, :cardName, :cardPower, :cardDefense, :cardDescription, :cardCost
end
