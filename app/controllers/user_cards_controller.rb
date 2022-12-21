class UserCardsController < ApplicationController


    def game_cards
        cards_with_details = {}
        game = Game.find(params[:game_id])
        game_cards = UserCard.where("game_id = ?", game.id).includes(:card)
        # game_cards.each {|card| }
        GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: game_cards}
        render json: game_cards, status: :ok
        # debugger
    end

    def create_random_deck
        random_deck = []
            3.times do
            card = Card.all.sample
            player_card = UserCard.create!(user_id: params[:player_id], card_id: card.id, game_id: params[:game_id])
            random_deck << player_card
            end
        render json: random_deck, status: :ok
    end

end
