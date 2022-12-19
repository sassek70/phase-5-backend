p "Creating users..."

User.create(username: "kev", password: "123456", gamesPlayed: 0, gamesWon: 0, gamesLost: 0)
User.create(username: "test", password: "123456", gamesPlayed: 0, gamesWon: 0, gamesLost: 0)

p "Users created successfully"

p "Creating cards..."

20.times do
    Card.create!(cardName: Faker::Fantasy::Tolkien.character, cardPower: rand(1..5), cardDefense: rand(1..5), cardDescription:Faker::Fantasy::Tolkien.poem, cardCost: rand(1..4))
end

p "Cards created successfully"

p "Assigning cards..."

seeded_cards = Card.all
seeded_cards.each { |card| UserCard.create(user_id: rand(1..2), card_id: card.id)}

p "Cards assigned"

p "Seeding Complete"