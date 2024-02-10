class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.references :dish, null: false, foreign_key: true
      t.string :date_time, default: -> {"CURRENT_TIMESTAMP"}

      t.timestamps
    end
  end
end
