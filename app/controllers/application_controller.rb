class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :invalid

    def current_user 
        auth_token = request.headers['uid']
        if auth_token
            token = JWT.decode(auth_token, ENV['JWT_TOKEN'])[0]
            return User.find_by( id: token['auth_token_id'])
        else
            return nil
        end
    end
    
    def authorize!
        unless current_user
            render json: { errors: ["You must be logged in"]}, status: :unauthorized
        end
    end
    
    private
    
    def not_found(error)
        render json: {error: "#{error.model} not found"}, status: :not_found
    end

    def invalid(error)
        render json: {errors: error.record.errors.full_messages}, status: :unprocessable_entity
    end
    
end
