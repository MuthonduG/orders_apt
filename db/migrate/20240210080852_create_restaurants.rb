class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :business_name
      t.string :avatar
      t.string :payment_method
      t.string :offers
      t.string :user_id
      t.string :email
      t.integer :login_attempts
      t.string :password_digest

      t.timestamps
    end
  end
end
