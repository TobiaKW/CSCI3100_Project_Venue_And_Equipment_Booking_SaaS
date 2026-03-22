# Used for fresh DBs (local or Render): run `db:migrate` after create.
# To rebuild Render: reset/drop DB in dashboard, then deploy with migrate (or run db:migrate once).
class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :departments, :name, unique: true

    create_table :users do |t|
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
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    create_table :resources do |t|
      t.string :name, null: false
      t.string :rtype, null: false
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
    add_index :resources, [ :department_id, :name ], unique: true

    create_table :bookings do |t|
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
