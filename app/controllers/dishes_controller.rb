class DishesController < ApplicationController

    def index
        @dishes = Dish.all
        render json: @dishes, status: :ok
    end

    def create_dish
        header = request.headers['Authorization']
        token = header.split(' ').last if header
    
        begin
            decode_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
            user_ref = decode_token[0]['user_ref']
            @user = User.find_by(user_id: user_ref)
    
            @dish = Dish.new(dish_params)
            @dish.user_id = @user.id
    
            if @dish.save
                render json: @dish, status: :created
            else
                render json: { error: "Cannot create the dish", details: @dish.errors.full_messages }, status: :unprocessable_entity
            end
        rescue JWT::DecodeError
            render json: { error: "Invalid token" }, status: :unauthorized
        rescue ActiveRecord::RecordNotFound
            render json: { error: "User not found" }, status: :unprocessable_entity
        end
    end
    
    private

    def dish_params
        params.permit(:user_id, :restaurant_id, :dish_id, :date_time)
    end
end
