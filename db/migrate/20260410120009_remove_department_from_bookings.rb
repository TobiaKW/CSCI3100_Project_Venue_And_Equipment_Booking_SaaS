class RemoveDepartmentFromBookings < ActiveRecord::Migration[7.2]
  def up
    remove_reference :bookings, :department, foreign_key: true
  end

  def down
    add_reference :bookings, :department, foreign_key: true
  end
end
