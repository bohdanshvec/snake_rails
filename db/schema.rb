
ActiveRecord::Schema[8.0].define(version: 2025_07_15_102833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "field_width"
    t.integer "field_height"
    t.integer "apples_count"
    t.integer "barriers_count"
    t.integer "collected_apples"
    t.integer "duration"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "users"
end
