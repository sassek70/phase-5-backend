class GameSessionController < ApplicationController
    @@counter = 0

    def increase_counter
        game = Game.find_by(game_key: params[:game_key])
        # action = PlayerAction.create!(game_key: game.game_key, count: 0)
        new_count = @@counter += 1
        # action.update!(counter: new_count)

        # game_key = params[:game_key]
        GameSessionChannel.broadcast_to game, {count: new_count}
        # GameSessionChannel.broadcast_to game, "hello"
        # serialized_data = ActiveModelSerializers::Adapter::Json.new(GameSerializer.new(game)).serializable_hash
        # ActionCable.server.broadcast game, new_count
        render json: new_count, status: :ok
    end


end
