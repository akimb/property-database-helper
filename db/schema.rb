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

ActiveRecord::Schema[8.1].define(version: 2026_02_15_001055) do
  create_table "imported_properties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.bigint "import_id", null: false
    t.string "name", null: false
    t.string "state"
    t.string "street_address"
    t.json "units"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.boolean "zip_valid", default: false
    t.index ["import_id"], name: "index_imported_properties_on_import_id"
  end

  create_table "imports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "filename"
    t.text "raw_csv"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_properties_on_name", unique: true
  end

  create_table "units", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "imported_property_id"
    t.bigint "property_id"
    t.string "unit_number"
    t.datetime "updated_at", null: false
    t.index ["imported_property_id"], name: "fk_rails_cd4469ef0f"
    t.index ["property_id"], name: "index_units_on_property_id"
  end

  add_foreign_key "imported_properties", "imports"
  add_foreign_key "units", "imported_properties"
  add_foreign_key "units", "properties"
end
