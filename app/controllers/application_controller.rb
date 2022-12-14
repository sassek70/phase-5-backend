class ApplicationController < ActionController::API

    def current_user 
        auth_token = request.headers['uid']
        if auth_token
            token = JWT.decode(auth_token, ENV['JWT_TOKEN'])[0]
            return User.find_by( id: token['auth_token_id'])
        else
            return nil
        end
        debugger
    end

    def authorize!
        unless current_user
            render json: { errors: ["You must be logged in"]}, status: :unauthorized
        end
    end

end
