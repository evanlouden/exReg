# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160531203831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "address",                                null: false
    t.string   "city",                                   null: false
    t.string   "state",                                  null: false
    t.string   "zip",                                    null: false
    t.boolean  "admin",                  default: false
    t.boolean  "teacher",                default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  end

  create_table "availabilities", force: :cascade do |t|
    t.string  "checked",    null: false
    t.string  "day",        null: false
    t.string  "start",      null: false
    t.string  "end",        null: false
    t.integer "inquiry_id", null: false
    t.index ["inquiry_id"], name: "index_availabilities_on_inquiry_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string  "first_name", null: false
    t.string  "last_name",  null: false
    t.string  "email",      null: false
    t.string  "phone",      null: false
    t.integer "account_id", null: false
    t.index ["account_id"], name: "index_contacts_on_account_id", using: :btree
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer "student_id", null: false
    t.string  "instrument", null: false
    t.text    "notes"
    t.index ["student_id"], name: "index_inquiries_on_student_id", using: :btree
  end

  create_table "instruments", force: :cascade do |t|
    t.string  "name"
    t.integer "inquiry_id"
    t.index ["inquiry_id"], name: "index_instruments_on_inquiry_id", using: :btree
  end

  create_table "students", force: :cascade do |t|
    t.string  "first_name", null: false
    t.string  "last_name",  null: false
    t.string  "school"
    t.date    "dob",        null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_students_on_account_id", using: :btree
  end

end
