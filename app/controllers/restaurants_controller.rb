class RestaurantsController < ApplicationController
    skip_before_action :authenticate

    def create_new_restaurant
        @restaurant = Restaurant.new(restaurant_params)
        @restaurant.user_id = generate_restaurant_id
        @restaurant.id = SecureRandom.hex(3)[0, 5]
        @restaurants = Restaurant.all

        if Restaurant.exists?(email: @restaurant.email)
            render json: { error: "User already exists" }
        else
            while @restaurants.any? { |existing_restaurant| existing_restaurant.user_id == @restaurant.user_id }
                @restaurant.user_id = generate_restaurant_id
            end

            if @restaurant.save
                render json: @restaurant, status: :created
            else
                render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
            end
        end

    end

    private

    def restaurant_params
        params.permit(:business_name, :email, :payment_method, :password, :avatar, :offers)
    end

    def generate_restaurant_id
        characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
        random_str = Array.new(12) { characters.sample }.join
        return "user_id: #{random_str}"
    end
end
