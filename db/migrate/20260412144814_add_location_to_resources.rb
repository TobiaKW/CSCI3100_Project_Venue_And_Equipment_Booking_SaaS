class AddLocationToResources < ActiveRecord::Migration[7.2]
  def change
    add_column :resources, :latitude, :decimal, precision: 10, scale: 6
    add_column :resources, :longitude, :decimal, precision: 10, scale: 6
  end
end
