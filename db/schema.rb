# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_10_033604) do
  create_table "bookings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "resource_id", null: false
    t.integer "department_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "status"
    t.index ["department_id"], name: "index_bookings_on_department_id"
    t.index ["resource_id"], name: "index_bookings_on_resource_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "rtype"
    t.integer "department_id", null: false
    t.index ["department_id"], name: "index_resources_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "role"
    t.integer "department_id", null: false
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  add_foreign_key "bookings", "departments"
  add_foreign_key "bookings", "resources"
  add_foreign_key "bookings", "users"
  add_foreign_key "resources", "departments"
  add_foreign_key "users", "departments"
end
