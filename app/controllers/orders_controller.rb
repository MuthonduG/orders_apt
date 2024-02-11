class OrdersController < ApplicationController

    def index
        @orders = Order.all
        render json: @orders, status: :ok
    end

    def create_order
        header = request.headers['Authorization']
        token = header.split(' ').last if header
    
        begin
            decode_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
            user_ref = decode_token[0]['user_ref']
            @user = User.find_by(user_id: user_ref)
    
            @order = Order.new(order_params)
            @order.user_id = @user.id
    
            if @order.save
                render json: @order, status: :created
            else
                render json: { error: "Cannot create the order" }, status: :unprocessable_entity
            end
        rescue JWT::DecodeError
            render json: { error: "Invalid token" }, status: :unauthorized
        rescue ActiveRecord::RecordNotFound
            render json: { error: "User not found" }, status: :unprocessable_entity
        end
    end
    
    private

    def order_params
        params.permit(:user_id, :restaurant_id, :dish_id, :date_time)
    end
    
end
