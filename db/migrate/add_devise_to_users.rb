class AddDeviseToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :encrypted_password, :string
    add_column :users, :reset_password_token, :string
    default: "", null: false on encrypted_password
    add_index :users, :reset_password_token, unique: true
    add_index :users, :email, unique: true
  end
end
