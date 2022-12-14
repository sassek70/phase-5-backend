class SessionsController < ApplicationController

    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            auth_token = JWT.encode({auth_token_id: user.id, username: user.username}, ENV['JWT_TOKEN'])
            render json: { auth_token: auth_token } , status: :created
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    def existing_token
            # JWT params put the token on the key "_json"
            token = JWT.decode(params[:_json], ENV['JWT_TOKEN'])[0]
            user = User.find_by(id: token['auth_token_id'])
            render json: user, status: :ok
    end
end
