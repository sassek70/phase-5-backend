class GameActionsController < ApplicationController

    def update
        action = GameAction.find_by(game_key: params[:game_key])
        new_count = action.count += 1
        action.update!(count: new_count)
    end
end
