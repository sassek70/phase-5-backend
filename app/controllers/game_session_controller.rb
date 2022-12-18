class GameSessionController < ApplicationController
    @@counter = 0
    # def increase_counter
    #     target_action = GameAction.find_by(game_key: params[:game_key])
    #     # target_action.update(count: count += 1)
    #     # target.update!(count: new_count)
    #     game = Game.find_by(game_key: params[:game_key])
        
    #     GameSessionChannel.broadcast_to game, new_count
    #     render json: new_count, status: :ok
    # end

    def increase_counter
        # action = GameAction.find_by(game_key: params[:game_key])
        new_count = @@counter += 1
        # action.update!(counter: new_count)
        game = Game.find_by(game_key: params[:game_key])
        # game_key = params[:game_key]
        GameSessionChannel.broadcast_to game, new_count
        # GameSessionChannel.broadcast_to game, "hello"
        # serialized_data = ActiveModelSerializers::Adapter::Json.new(GameSerializer.new(game)).serializable_hash
        # ActionCable.server.broadcast game, new_count
        render json: new_count, status: :ok
    end


end
