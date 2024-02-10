class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :school_id
      t.string :email
      t.string :phone_number
      t.string :password_digest
      t.string :user_id

      t.timestamps
    end
  end
end
