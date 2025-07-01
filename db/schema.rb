ActiveRecord::Schema[8.0].define(version: 2025_07_01_065344) do
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
