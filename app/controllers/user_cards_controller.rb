class UserCardsController < ApplicationController

    def create_random_deck
        random_deck = []
            card = Card.all.sample
            player_card = UserCard.create!(user_id: params[:player_id], card_id: card.id, game_key: params[:game_key])
            random_deck << player_card
        render json: random_deck, status: :ok
    end

end
