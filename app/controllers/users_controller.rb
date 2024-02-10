class UsersController < ApplicationController
    skip_before_action :authenticate, only: [:sign_up_user]

    def index
        @user = User.all 
        render json: @user, status: :ok
    end

    def sign_up_user
        @user = User.new(user_params)
        @user.user_id = generate_user_id
        @user_all = User.all
      
        if User.exists?(email: @user.email)
          render json: { error: "User already exists" }
        else
          # Check if the generated user_id already exists in any user
          while @user_all.any? { |existing_user| existing_user.user_id == @user.user_id }
            @user.user_id = generate_user_id
          end
      
          if @user.save
            render json: @user, status: :created
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end
    end

    def destroy_user
        @user = find_user
        @user.destroy
        head :no_content
    end

    private

    def user_params
        params.permit(:school_id, :email, :phone_number, :password, :user_id)
    end

    def find_user
        User.find(params[:user_id])
    end

    def generate_user_id
        characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
        random_str = Array.new(12) { characters.sample }.join
        return "order_user: #{random_str}"
    end
end
