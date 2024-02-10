class CreateDishes < ActiveRecord::Migration[7.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :category
      t.string :description
      t.string :status
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
