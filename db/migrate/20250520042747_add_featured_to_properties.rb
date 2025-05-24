class AddFeaturedToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :featured, :boolean
  end
end
