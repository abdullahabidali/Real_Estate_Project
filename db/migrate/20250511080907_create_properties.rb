class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :area
      t.string :property_type
      t.string :status

      t.timestamps
    end
  end
end
