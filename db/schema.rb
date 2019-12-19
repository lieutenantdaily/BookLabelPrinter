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

ActiveRecord::Schema.define(version: 2019_12_19_201130) do

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
    t.string "inventory_price"
    t.string "sold_price"
    t.string "wholesale_price"
    t.string "difference"
  end

end
