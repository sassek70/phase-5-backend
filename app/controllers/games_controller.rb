class GamesController < ApplicationController


    before_action :authorize!, only: [:create_game]

    def create_game
        new_game = Game.create!(host_user_id: params[:id])
        user = User.find(params[:id])
        # increase_games = user.gamesPlayed + 1
        user.update!(gamesPlayed: user.gamesPlayed + 1)
        # debugger
        # user.update!(gamesPlayed: user.gamesPlayed += 1)
        # user.update_attribute(:gamesPlayed, increase_games)
        render json: new_game, status: :ok

    end

    # def results
    #     game = Game.find_by!(game_key: params[:game_key])
    #     winner = User.find(params[:winning_player_user_id])
    #     increase_wins = winner.gamesWon + 1
    #     update_rate = (increase_wins.to_f / winner.gamesPlayed.to_f) * 100
    #     game.update!(winning_player_id: winner.id)
    #     winner.update!(gamesWon: increase_wins, win_rate: update_rate.round(2))
    #     # debugger
    # end



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

    private

    def game_params
        params.permit(:user_id, :game_token)
    end

end
