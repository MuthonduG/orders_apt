class OauthController < ApplicationController

    def login
        max_attempts = 3
        @user = User.find_by(school_id: params[:school_id])
        attempts_remaining = max_attempts - (@user&.login_attempts || 0)
      
        if attempts_remaining > 0
          if @user && @user.authenticate(params[:password])
            user_token = generate_token(@user)
            # Reset login attempts on successful login
            @user.update(login_attempts: 0)
            render json: { token: user_token }, status: :ok
          else
            # Increment login attempts on unsuccessful login
            @user.increment!(:login_attempts)
            render json: { error: "Invalid password. Attempts remaining: #{attempts_remaining}" }
          end
        else
          render json: { error: "Account locked. Please contact support." }, status: :locked
        end
    end
      

    private

    def generate_token
        expiration = Time.now.to_i + 2.hour.to_i

        payload = {
            user_ref: @user.user_id,
            exp: expiration
        }
        JWT.encode(payload, Rails.application.secret_key_base)
    end
end
