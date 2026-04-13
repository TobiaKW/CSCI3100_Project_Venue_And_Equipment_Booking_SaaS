class AddAddressToResource < ActiveRecord::Migration[7.2]
  def change
    add_column :resources, :address, :string
  end
end
