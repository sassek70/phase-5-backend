class UserGamesController < ApplicationController


    def create_key
        game_key = key_generator
        new_game = UserGame.create!(user_id: params[:user_id], game_id: game_key)
        render json: game_key, status: :ok
    end

    private

    def game_params
        params.permit(:user_id)
    end

    def key_generator
        letters = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
        game_key = (0...50).map { letters[rand(letters.length)] }.join
    end
end
