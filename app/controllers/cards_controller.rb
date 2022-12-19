class CardsController < ApplicationController
    require 'rest-client'

    # Testing rails fetch
    # def get_card
    #     # 20.times do
    #         url = "https://api.magicthegathering.io/v1/cards?page=22"
    #         response = RestClient.get(url)
    #         new_card = Card.create!(cardName: response.name, )
    #     render json: response
    # end

    def create
        10.times do
            new_card = Card.create!(cardName: Faker::Fantasy::Tolkien.character, cardPower: rand(1..5), cardDefense: rand(1..5), cardDescription:Faker::Fantasy::Tolkien.poem, cardCost: rand(1..4))
        end
        render json: Card.all
    end

    def get_card
        # 10.times do
            url = "https://api.scryfall.com/cards/random"
            response = RestClient.get(url)
            # if response.type_line.include? "Creature"
                # new_card = Card.create!(cardName: response[:name])
                    # cardPower: response.power, cardDefense: response.toughness, cardDescription: "#{response.artist}, #{response.image_uris.art_crop}", cardCost: resposne.cmc)
                # sleep 0.5
            # else
                # sleep 0.5
                # return
            # end
        # end
        # render json: new_card
        render json: response
    end
end






# { SCRY API
#     "object": "card",
#     "id": "62982dab-4c27-45b3-9740-38fec3df7226",
#     "oracle_id": "011bb6cc-f1a1-4790-befc-373acabf63b8",
#     "multiverse_ids": [
#         21343
#     ],
#     "mtgo_id": 13921,
#     "mtgo_foil_id": 13922,
#     "tcgplayer_id": 7126,
#     "cardmarket_id": 11800,
#     "name": "Arc Mage",
#     "lang": "en",
#     "released_at": "2000-02-14",
#     "uri": "https://api.scryfall.com/cards/62982dab-4c27-45b3-9740-38fec3df7226",
#     "scryfall_uri": "https://scryfall.com/card/nem/77/arc-mage?utm_source=api",
#     "layout": "normal",
#     "highres_image": true,
#     "image_status": "highres_scan",
#     "image_uris": {
#         "small": "https://cards.scryfall.io/small/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.jpg?1562630243",
#         "normal": "https://cards.scryfall.io/normal/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.jpg?1562630243",
#         "large": "https://cards.scryfall.io/large/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.jpg?1562630243",
#         "png": "https://cards.scryfall.io/png/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.png?1562630243",
#         "art_crop": "https://cards.scryfall.io/art_crop/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.jpg?1562630243",
#         "border_crop": "https://cards.scryfall.io/border_crop/front/6/2/62982dab-4c27-45b3-9740-38fec3df7226.jpg?1562630243"
#     },
#     "mana_cost": "{2}{R}",
#     "cmc": 3.0,
#     "type_line": "Creature — Human Spellshaper",
#     "oracle_text": "{2}{R}, {T}, Discard a card: Arc Mage deals 2 damage divided as you choose among one or two targets.",
#     "power": "2",
#     "toughness": "2",
#     "colors": [
#         "R"
#     ],
#     "color_identity": [
#         "R"
#     ],
#     "keywords": [],
#     "legalities": {
#         "standard": "not_legal",
#         "future": "not_legal",
#         "historic": "not_legal",
#         "gladiator": "not_legal",
#         "pioneer": "not_legal",
#         "explorer": "not_legal",
#         "modern": "not_legal",
#         "legacy": "legal",
#         "pauper": "not_legal",
#         "vintage": "legal",
#         "penny": "not_legal",
#         "commander": "legal",
#         "brawl": "not_legal",
#         "historicbrawl": "not_legal",
#         "alchemy": "not_legal",
#         "paupercommander": "restricted",
#         "duel": "legal",
#         "oldschool": "not_legal",
#         "premodern": "legal"
#     },
#     "games": [
#         "paper",
#         "mtgo"
#     ],
#     "reserved": false,
#     "foil": true,
#     "nonfoil": true,
#     "finishes": [
#         "nonfoil",
#         "foil"
#     ],
#     "oversized": false,
#     "promo": false,
#     "reprint": false,
#     "variation": false,
#     "set_id": "fa5d1fdb-f781-473d-b14d-50396d40d43f",
#     "set": "nem",
#     "set_name": "Nemesis",
#     "set_type": "expansion",
#     "set_uri": "https://api.scryfall.com/sets/fa5d1fdb-f781-473d-b14d-50396d40d43f",
#     "set_search_uri": "https://api.scryfall.com/cards/search?order=set&q=e%3Anem&unique=prints",
#     "scryfall_set_uri": "https://scryfall.com/sets/nem?utm_source=api",
#     "rulings_uri": "https://api.scryfall.com/cards/62982dab-4c27-45b3-9740-38fec3df7226/rulings",
#     "prints_search_uri": "https://api.scryfall.com/cards/search?order=released&q=oracleid%3A011bb6cc-f1a1-4790-befc-373acabf63b8&unique=prints",
#     "collector_number": "77",
#     "digital": false,
#     "rarity": "uncommon",
#     "card_back_id": "0aeebaf5-8c7d-4636-9e82-8c27447861f7",
#     "artist": "Terese Nielsen",
#     "artist_ids": [
#         "eb55171c-2342-45f4-a503-2d5a75baf752"
#     ],
#     "illustration_id": "ae90ac2e-3e83-438c-8670-6c2916addc4b",
#     "border_color": "black",
#     "frame": "1997",
#     "full_art": false,
#     "textless": false,
#     "booster": true,
#     "story_spotlight": false,
#     "edhrec_rank": 22715,
#     "prices": {
#         "usd": "0.15",
#         "usd_foil": "0.39",
#         "usd_etched": null,
#         "eur": "0.18",
#         "eur_foil": "0.80",
#         "tix": "0.04"
#     },
#     "related_uris": {
#         "gatherer": "https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=21343",
#         "tcgplayer_infinite_articles": "https://infinite.tcgplayer.com/search?contentMode=article&game=magic&partner=scryfall&q=Arc+Mage&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall",
#         "tcgplayer_infinite_decks": "https://infinite.tcgplayer.com/search?contentMode=deck&game=magic&partner=scryfall&q=Arc+Mage&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall",
#         "edhrec": "https://edhrec.com/route/?cc=Arc+Mage"
#     },
#     "purchase_uris": {
#         "tcgplayer": "https://www.tcgplayer.com/product/7126?page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall",
#         "cardmarket": "https://www.cardmarket.com/en/Magic/Products/Search?referrer=scryfall&searchString=Arc+Mage&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall",
#         "cardhoarder": "https://www.cardhoarder.com/cards/13921?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall"
#     }
# }




# { MTG API
#     "card": {
#         "name": "Ankh of Mishra",
#         "manaCost": "{2}",
#         "cmc": 2.0,
#         "type": "Artifact",
#         "types": [
#             "Artifact"
#         ],
#         "rarity": "Rare",
#         "set": "LEA",
#         "setName": "Limited Edition Alpha",
#         "text": "Whenever a land enters the battlefield, Ankh of Mishra deals 2 damage to that land's controller.",
#         "artist": "Amy Weber",
#         "number": "230",
#         "layout": "normal",
#         "multiverseid": "1",
#         "imageUrl": "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=1&type=card",
#         "rulings": [
#             {
#                 "date": "2004-10-04",
#                 "text": "This triggers on any land entering the battlefield. This includes playing a land or putting a land onto the battlefield using a spell or ability."
#             },
#             {
#                 "date": "2004-10-04",
#                 "text": "It determines the land’s controller at the time the ability resolves. If the land leaves the battlefield before the ability resolves, the land’s last controller before it left is used."
#             }
#         ],
#         "printings": [
#             "2ED",
#             "3ED",
#             "4BB",
#             "4ED",
#             "5ED",
#             "6ED",
#             "CED",
#             "CEI",
#             "FBB",
#             "LEA",
#             "LEB",
#             "ME1",
#             "SUM",
#             "VMA"
#         ],
#         "originalText": "Ankh does 2 damage to anyone who puts a new land into play.",
#         "originalType": "Continuous Artifact",
#         "legalities": [
#             {
#                 "format": "Commander",
#                 "legality": "Legal"
#             },
#             {
#                 "format": "Duel",
#                 "legality": "Legal"
#             },
#             {
#                 "format": "Legacy",
#                 "legality": "Legal"
#             },
#             {
#                 "format": "Oldschool",
#                 "legality": "Legal"
#             },
#             {
#                 "format": "Premodern",
#                 "legality": "Legal"
#             },
#             {
#                 "format": "Vintage",
#                 "legality": "Legal"
#             }
#         ],
#         "id": "33b9ca30-0296-52b7-a8e2-7d4715404b0d"
#     }
# }