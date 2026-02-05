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

ActiveRecord::Schema[8.1].define(version: 2026_02_04_204955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_favorites_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "address"
    t.integer "budget_dinner"
    t.integer "budget_lunch"
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "genre"
    t.boolean "is_open"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "name"
    t.jsonb "opening_hours"
    t.decimal "rating"
    t.string "reservation_url"
    t.string "sns_facebook"
    t.string "sns_instagram"
    t.string "sns_twitter"
    t.string "source"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "favorites", "restaurants"
end
