ActiveRecord::Schema[7.2].define(version: 0) do
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "role"
    t.bigint "department_id", null: false
    t.string "reset_password_token"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "rtype"
    t.bigint "department_id", null: false
    t.index ["department_id"], name: "index_resources_on_department_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resource_id", null: false
    t.bigint "department_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "status"
    t.index ["department_id"], name: "index_bookings_on_department_id"
    t.index ["resource_id"], name: "index_bookings_on_resource_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  add_foreign_key "bookings", "departments"
  add_foreign_key "bookings", "resources"
  add_foreign_key "bookings", "users"
  add_foreign_key "resources", "departments"
  add_foreign_key "users", "departments"
end
