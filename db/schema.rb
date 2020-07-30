# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_29_195418) do

  create_table "buybacks", force: :cascade do |t|
    t.string "order_id"
    t.string "price"
    t.string "isbn"
    t.string "condition"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "buyback_id"
    t.string "order_hash"
    t.string "tracking_number"
    t.string "title"
    t.string "restricted"
    t.string "o_created_at"
    t.string "status"
    t.string "notes"
    t.string "updated_by"
    t.string "vendor"
    t.string "shipper"
    t.string "tbm_price"
    t.string "tracking_number2"
    t.index ["buyback_id"], name: "index_buybacks_on_buyback_id", unique: true
  end

  create_table "compare_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "isbn"
    t.string "inventory_price"
    t.string "sold_price"
    t.string "wholesale_price"
    t.string "difference"
  end

  create_table "offers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "isbn"
    t.string "tbm_amount"
    t.string "rank"
    t.string "suggested_bid"
    t.string "quantity"
    t.string "minimum"
    t.string "bid"
    t.string "min_qty"
  end

  create_table "prices", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "isbn"
    t.string "amount"
    t.string "source"
    t.string "rank"
    t.string "difference"
    t.string "buy_qty"
    t.string "title"
    t.string "vendor_qty"
    t.string "qty_difference"
    t.string "final_qty"
    t.string "total"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin"
    t.boolean "power_user"
    t.boolean "active"
    t.string "custom"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
