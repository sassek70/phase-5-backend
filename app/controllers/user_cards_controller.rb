class UserCardsController < ApplicationController

    def create_random_deck
        game = Game.find(params[:game_id])
        random_deck = []
        30.times do
            # card = Card.first
            card = Card.all.sample
            player_card = UserCard.create!(user_id: params[:player_id], card_id: card.id, game_id: params[:game_id])
            random_deck << player_card

        end
        game_cards = UserCard.where("game_id = ?", game.id)
        GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: game_cards.map{|game_card| UserCardSerializer.new(game_card)}, card_map: get_card_map(game_cards)}
        render json: random_deck, status: :ok

    end

    def get_card_map(game_cards)
        # start with empty object, for each game card, create an adding to the empty object as 
        game_cards.each_with_object({}) do |game_card,hash|
        hash[game_card.id] = game_card.card
        end
    end

end
