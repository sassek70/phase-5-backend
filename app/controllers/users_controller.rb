class UsersController < ApplicationController

    def create
        render json: User.create!(user_params)
    end

    private

    def user_params
        params.permit(:username, :password_digest)
    end

end
