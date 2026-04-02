class AddCapacityAndSeatTypeToResources < ActiveRecord::Migration[7.2]
  def change
    add_column :resources, :capacity, :integer, default: -1
    add_column :resources, :seat_type, :string, default: 'N/A'
  end
end
