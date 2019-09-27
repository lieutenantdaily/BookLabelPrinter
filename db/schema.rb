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

ActiveRecord::Schema.define(version: 2019_09_27_100217) do

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

end
