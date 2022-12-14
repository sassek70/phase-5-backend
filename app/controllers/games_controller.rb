class GamesController < ApplicationController



    def create_game
        new_game = Game.create!(host_user_id: params[:id])
        # game_key = key_generator(user_id: params[:user_id], game_key: new_game.game_key)
        # game_key = key_generator
        # render json: {game_key: game_key.gsub(".", "-"), new_game: new_game}, status: :ok
        render json: {new_game: new_game}, status: :ok
    end

    # def join_game
        # game_token = params[:game_key]
        # formatted_game_token = game_token.gsub("-", ".")
        # debugger
        # decoded_token = JWT.decode(game_token, ENV['GAME_TOKEN'])
    # end

    def join_game
        game = Game.find_by(game_key: params[:game_key])
        game.update!(opponent_id: params[:id])
        render json: {game: game, messages: ["Game joined successfully"]}
    end

    private

    def game_params
        params.permit(:user_id, :game_token)
    end

    # def key_generator(user_id:, game_key:)
    #     payload = {user_id: user_id, game_key: game_key}
    #     game_token = JWT.encode({payload: payload}, ENV['GAME_TOKEN'])
    #     debugger
    # end
end
