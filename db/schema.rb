ActiveRecord::Schema[7.2].define(version: 0) do
    create_table "departments", force: :cascade do |t|
        t.string "name"
    end
    create_table "users", force: :cascade do |t|
        t.string "email"
        t.string "password"
        t.string "name"
        t.string "role"
        t.references "department", null: false, foreign_key: true
    end
    create_table "resources", force: :cascade do |t|
        t.string "name"
        t.string "rtype"
        t.references "department", null: false, foreign_key: true
    end
    create_table "bookings", force: :cascade do |t|
        t.references "user", null: false, foreign_key: true
        t.references "resource", null: false, foreign_key: true
        t.references "department", null: false, foreign_key: true
        t.datetime "start_time"
        t.datetime "end_time"
        t.string "status"
    end
end
