class GamesController < ApplicationController


    def create_game
        new_game = Game.create!(user_id: params[:user_id])
        game_key = key_generator({user_id: params[:user_id], user_game_id: new_game.id})
        render json: {game_key: game_key.gsub(".", "-"), new_game: new_game}, status: :ok
    end

    def join_game
        game_token = params[:game_token]
        formatted_game_token = game_token.gsub("-", ".")
        # debugger
        debugger
        decoded_token = JWT.decode(formatted_game_token, ENV['GAME_TOKEN'])
    end

    private

    def game_params
        params.permit(:user_id, :game_token)
    end

    def key_generator(user_id:, user_game_id:)
        payload = {user_id: user_id, user_game_id: user_game_id}
        game_token = JWT.encode({payload: payload}, ENV['GAME_TOKEN'])
        # debugger
        # letters = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
        # game_key = (0...50).map { letters[rand(letters.length)] }.join
    end
end
