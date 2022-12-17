class GameSessionController < ApplicationController

    @@counter = 0

    def increase_counter
        new_count = @@counter += 1
        game = Game.find_by(game_key: params[:game_key])
        GameSessionChannel.broadcast_to game, new_count
        render json: new_count, status: :ok
    end


end
