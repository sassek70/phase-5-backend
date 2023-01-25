class GamesController < ApplicationController

    before_action :authorize!, only: [:create_game]

    def create_game
        new_game = Game.create!(host_user_id: params[:id])
        user = User.find(params[:id])
        user.update!(gamesPlayed: user.gamesPlayed + 1)
        render json: new_game, status: :ok

    end

    def join_game
        game = Game.find_by!(game_key: params[:game_key])
        user = User.find(params[:opponent_id])
        if game.opponent_id != nil
            return render json: {error: "Game is full" }, status: :unprocessable_entity
        else 
            game.update!(opponent_id: params[:opponent_id])
            user.update!(gamesPlayed: user.gamesPlayed + 1)
            GameSessionChannel.broadcast_to game, {action: "user-joined", game: game, message: "Opponent has joined the game"}
            render json: game, status: :accepted
        end
    end

    def update
        game = Game.find_by!(game_key: params[:game_key])
        game.update!(draw: params[:draw])
        head :ok
    end

end
