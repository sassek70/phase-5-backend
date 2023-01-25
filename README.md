## Getting started

1. Make sure PostgreSQL server is running
  `sudo service postgresql start`
  
2. Start the Rails server - default: localhost:3000
  run `rails s` in the terminal

3. To run this program locally, you will need to seed the database with the card data from the [Scryfall API](https://scryfall.com/docs/api/cards). By default, the 200 cards will be created and added to the database. You can change this number by altering the `seeds.rb` file located at `/db/seeds.rb`
 
 Note: `sleep 0.1` is required to limit the rate at which api calls are being made to meet the API requirements.
