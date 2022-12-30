require 'rest-client'


p "Creating users..."

User.create(username: "kev", password: "123456", gamesPlayed: 0, gamesWon: 0, win_rate: 0)
User.create(username: "test", password: "123456", gamesPlayed: 0, gamesWon: 0, win_rate: 0)

p "Users created successfully"

p "Creating cards..."
created_cards = 0
until created_cards == 5 do
    url = "https://api.scryfall.com/cards/random"
    response = RestClient.get(url)
    parsed = JSON.parse(response)
    if parsed["type_line"].include?("Creature") && parsed["power"] >= "0" && parsed["toughness"] >= "0" && parsed["image_uris"]["art_crop"] && parsed["cmc"] && parsed["mtgo_id"]
        new_card = Card.new(cardName: parsed["name"], cardPower: parsed["power"], cardDefense: parsed["toughness"], cardArtist: "#{parsed["artist"]}", cardDescription: "Art-crop image provided by: https://scryfall.com/", cardImage: "#{parsed["image_uris"]["art_crop"]}", mtgo_id: parsed["mtgo_id"], cardCost: parsed["cmc"])
         if new_card.valid?
            new_card.save
            created_cards += 1
            p "card number #{created_cards} created successfully"
         else
            p "card invalid"
         end
        sleep 0.1
    else
        p "not a creature"
        sleep 0.1
        # return
    end
end

p "Cards created successfully"

# p "Assigning cards..."

# seeded_cards = Card.all
# seeded_cards.each { |card| UserCard.create(user_id: rand(1..2), card_id: card.id)}

# p "Cards assigned"

p "Seeding Complete"