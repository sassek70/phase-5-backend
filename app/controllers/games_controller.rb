class GamesController < ApplicationController



    def create_game
        new_game = Game.create!(host_user_id: params[:id])
        # game_key = key_generator(user_id: params[:user_id], game_key: new_game.game_key)
        # game_key = key_generator
        # render json: {game_key: game_key.gsub(".", "-"), new_game: new_game}, status: :ok
        GameAction.create!(game_key: new_game.game_key, count: 0)
        render json: new_game, status: :ok
    end

    # def join_game
        # game_token = params[:game_key]
        # formatted_game_token = game_token.gsub("-", ".")
        # debugger
        # decoded_token = JWT.decode(game_token, ENV['GAME_TOKEN'])
    # end

    def join_game
        game = Game.find_by!(game_key: params[:game_key])
        if game.opponent_id != nil
            return render json: {error: "Game is full" }, status: :unprocessable_entity
        else 
            game.update!(opponent_id: params[:id])
            5.times do
                UserCard.create!(user_id: params[:id])
            end
            # GameSessionChannel.broadcast_to game.user, {message: "#{game.opponent_id} has joined the game"}
            render json: game, status: :accepted
        end
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
