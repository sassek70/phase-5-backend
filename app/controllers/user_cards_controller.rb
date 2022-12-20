class UserCardsController < ApplicationController

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
