class ApplicationController < ActionController::API
    before_action :authenticate

    def authenticate
        header = request.headers['Authorization']
        token = header.split(' ').last if header

        if token
            begin
                decode_token = JWT.decode(token, Rails.application.secret_key_base)

                if decode_token[0]['exp'] < Time.now.to_i
                    render json: { error: "Token has expired" }, status: :unauthorized
                else
                    user_ref = decode_token[0]['user_ref']
                    @current_user = User.find_by(user_id: user_ref)
                    
                    unless @current_user
                        render json: { error: "Unauthorized" }, status: :unauthorized
                    end
                end
            rescue JWT::DecodeError
                render json: { error: "Invalid token" }, status: :unauthorized
            end
        else
            render json: { error: 'Token not provided'}, status: :unauthorized
        end
    end
end
