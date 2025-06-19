ActiveRecord::Schema[8.0].define(version: 2025_05_20_085343) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "count"
    t.text "field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
