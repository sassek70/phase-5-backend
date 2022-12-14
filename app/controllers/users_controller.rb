class UsersController < ApplicationController

    before_action :authorize!, only: [:update, :delete]

    def create
        render json: User.create!(user_params)
    end

    def update
        user = User.find(params[:id])
        user.update!(user_params)
        render json: user, status: :accepted
    end

    private

    def user_params
        params.permit(:username, :password)
    end

end
