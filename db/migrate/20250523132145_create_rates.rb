class CreateRates < ActiveRecord::Migration[8.0]
  def change
    create_table :rates do |t|
      t.references :rater, null: false, foreign_key: { to_table: :users }
      t.references :rateable, polymorphic: true, null: false
      t.integer :stars
      t.string :dimension

      t.timestamps
    end
  end
end
