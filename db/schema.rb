# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_28_194622) do

  create_table "docks", force: :cascade do |t|
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "name"
    t.index ["location_id"], name: "index_docks_on_location_id"
    t.index ["slug"], name: "index_docks_on_slug", unique: true
  end

  create_table "double_entry_account_balances", force: :cascade do |t|
    t.string "account", limit: 31, null: false
    t.string "scope", limit: 23
    t.integer "balance", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account"], name: "index_account_balances_on_account"
    t.index ["scope", "account"], name: "index_account_balances_on_scope_and_account", unique: true
  end

  create_table "double_entry_line_aggregates", force: :cascade do |t|
    t.string "function", limit: 15, null: false
    t.string "account", limit: 31, null: false
    t.string "code", limit: 47
    t.string "scope", limit: 23
    t.integer "year"
    t.integer "month"
    t.integer "week"
    t.integer "day"
    t.integer "hour"
    t.integer "amount", null: false
    t.string "filter"
    t.string "range_type", limit: 15, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["function", "account", "code", "year", "month", "week", "day"], name: "line_aggregate_idx"
  end

  create_table "double_entry_line_checks", force: :cascade do |t|
    t.integer "last_line_id", null: false
    t.boolean "errors_found", null: false
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "double_entry_line_metadata", force: :cascade do |t|
    t.integer "line_id", null: false
    t.string "key", limit: 48, null: false
    t.string "value", limit: 64, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_id", "key", "value"], name: "lines_meta_line_id_key_value_idx"
  end

  create_table "double_entry_lines", force: :cascade do |t|
    t.string "account", limit: 31, null: false
    t.string "scope", limit: 23
    t.string "code", limit: 47, null: false
    t.integer "amount", null: false
    t.integer "balance", null: false
    t.integer "partner_id"
    t.string "partner_account", limit: 31, null: false
    t.string "partner_scope", limit: 23
    t.integer "detail_id"
    t.string "detail_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account", "code", "created_at"], name: "lines_account_code_created_at_idx"
    t.index ["account", "created_at"], name: "lines_account_created_at_idx"
    t.index ["scope", "account", "created_at"], name: "lines_scope_account_created_at_idx"
    t.index ["scope", "account", "id"], name: "lines_scope_account_id_idx"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "coordinate_x"
    t.integer "coordinate_y"
    t.integer "coordinate_z"
    t.index ["slug"], name: "index_locations_on_slug", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "ship_id"
    t.integer "user_id"
    t.index ["location_id"], name: "index_people_on_location_id"
    t.index ["ship_id"], name: "index_people_on_ship_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "ship_boarding_requests", force: :cascade do |t|
    t.integer "ship_id"
    t.integer "requester_id"
    t.index ["requester_id"], name: "index_ship_boarding_requests_on_requester_id"
    t.index ["ship_id"], name: "index_ship_boarding_requests_on_ship_id"
  end

  create_table "ship_computers", force: :cascade do |t|
    t.string "reference"
    t.integer "ship_id"
    t.index ["ship_id"], name: "index_ship_computers_on_ship_id"
  end

  create_table "ships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "dock_id"
    t.string "name"
    t.string "slug"
    t.integer "fuel", default: 0, null: false
    t.index ["dock_id"], name: "index_ships_on_dock_id"
    t.index ["location_id"], name: "index_ships_on_location_id"
    t.index ["slug"], name: "index_ships_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
