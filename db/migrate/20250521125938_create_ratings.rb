class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.belongs_to :rater
      t.belongs_to :rateable, polymorphic: true
      t.float :stars, null: false
      t.string :dimension
      t.timestamps
    end

    add_index :ratings, :rater_id, name: 'index_ratings_on_rater_id_custom'
    add_index :ratings, [:rateable_id, :rateable_type]
  end
end
