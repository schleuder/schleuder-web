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

ActiveRecord::Schema[7.0].define(version: 2015_12_28_112407) do
  create_table "account_requests", force: :cascade do |t|
    t.string "token", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["token"], name: "index_account_requests_on_token", unique: true
  end

  create_table "accounts", force: :cascade do |t|
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

end
