class UsersController < ApplicationController

    # skip_before_action :authorize!, only: [:update]
    before_action :authorize!, only: [:update, :delete]


    def leaderboard
        users = User.all 
        render json: users.order(win_rate: :DESC), status: :ok
    end

    def create
        user = User.create!(user_params)
        auth_token = JWT.encode({auth_token_id: user.id, username: user.username}, ENV['JWT_TOKEN'])
        render json: { auth_token: auth_token, user: user } , status: :created
    end

    def update
        user = User.find(params[:id])
        user.update!(user_params)
        render json: user, status: :accepted
    end

    def stats
        user = User.find(params[:id])
        render json: user, status: :ok
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        head :ok
    end

    private

    def user_params
        params.permit(:id, :username, :password, :gamesPlayed, :gamesWon)
    end

end
