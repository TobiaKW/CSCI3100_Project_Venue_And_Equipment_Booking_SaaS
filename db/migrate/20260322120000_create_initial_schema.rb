# Used for fresh DBs (local or Render): run `db:migrate` after create.
#
# `if_not_exists` / `if_not_exists` on indexes: safe when tables already exist but
# `schema_migrations` never recorded this version (e.g. DB created manually or from schema load).
class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :departments, if_not_exists: true do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :departments, :name, unique: true, if_not_exists: true

    create_table :users, if_not_exists: true do |t|
      ## Devise
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      ## App
      t.string :name
      t.string :role
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
    add_index :users, :email, unique: true, if_not_exists: true
    add_index :users, :reset_password_token, unique: true, if_not_exists: true

    create_table :resources, if_not_exists: true do |t|
      t.string :name, null: false
      t.string :rtype, null: false
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
    add_index :resources, [ :department_id, :name ], unique: true, if_not_exists: true

    create_table :bookings, if_not_exists: true do |t|
      t.references :user, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
  end
end
