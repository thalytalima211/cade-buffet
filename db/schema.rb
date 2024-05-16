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

ActiveRecord::Schema[7.1].define(version: 2024_05_06_223306) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "buffet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_id"], name: "index_admins_on_buffet_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "buffet_payment_methods", force: :cascade do |t|
    t.integer "buffet_id", null: false
    t.integer "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_id"], name: "index_buffet_payment_methods_on_buffet_id"
    t.index ["payment_method_id"], name: "index_buffet_payment_methods_on_payment_method_id"
  end

  create_table "buffets", force: :cascade do |t|
    t.string "corporate_name"
    t.string "brand_name"
    t.string "registration_number"
    t.string "number_phone"
    t.string "email"
    t.string "full_address"
    t.string "neighborhood"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id", null: false
    t.index ["admin_id"], name: "index_buffets_on_admin_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "min_guests"
    t.integer "max_guests"
    t.integer "default_duration"
    t.string "menu"
    t.boolean "offer_drinks"
    t.boolean "offer_decoration"
    t.boolean "offer_parking_service"
    t.integer "default_address"
    t.decimal "min_value", precision: 10, scale: 2
    t.decimal "additional_per_guest", precision: 10, scale: 2
    t.decimal "extra_hour_value", precision: 10, scale: 2
    t.decimal "weekend_min_value", precision: 10, scale: 2
    t.decimal "weekend_additional_per_guest", precision: 10, scale: 2
    t.decimal "weekend_extra_hour_value", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "buffet_id", null: false
    t.index ["buffet_id"], name: "index_event_types_on_buffet_id"
  end

  create_table "events", force: :cascade do |t|
    t.date "expiration_date"
    t.decimal "surcharge", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.string "description"
    t.decimal "final_value", precision: 10, scale: 2
    t.integer "payment_method_id", null: false
    t.integer "status", default: 0
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id", null: false
    t.integer "buffet_id", null: false
    t.index ["buffet_id"], name: "index_events_on_buffet_id"
    t.index ["customer_id"], name: "index_events_on_customer_id"
    t.index ["order_id"], name: "index_events_on_order_id"
    t.index ["payment_method_id"], name: "index_events_on_payment_method_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "buffet_id", null: false
    t.integer "event_type_id", null: false
    t.date "estimated_date"
    t.integer "number_of_guests"
    t.string "details"
    t.string "code"
    t.string "address"
    t.integer "status", default: 0
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "default_value", precision: 10, scale: 2
    t.index ["buffet_id"], name: "index_orders_on_buffet_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["event_type_id"], name: "index_orders_on_event_type_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "buffet_payment_methods", "buffets"
  add_foreign_key "buffet_payment_methods", "payment_methods"
  add_foreign_key "buffets", "admins"
  add_foreign_key "event_types", "buffets"
  add_foreign_key "events", "buffets"
  add_foreign_key "events", "customers"
  add_foreign_key "events", "orders"
  add_foreign_key "events", "payment_methods"
  add_foreign_key "orders", "buffets"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "event_types"
end
