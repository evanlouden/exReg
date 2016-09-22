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

ActiveRecord::Schema.define(version: 20160921200158) do

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
    t.string   "type"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  end

  create_table "adjusted_lessons", force: :cascade do |t|
    t.integer  "amount",         null: false
    t.date     "effective_date", null: false
    t.text     "reason",         null: false
    t.integer  "lesson_id",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["lesson_id"], name: "index_adjusted_lessons_on_lesson_id", using: :btree
  end

  create_table "availabilities", force: :cascade do |t|
    t.string  "checked",    null: false
    t.string  "day",        null: false
    t.time    "start_time"
    t.time    "end_time"
    t.integer "teacher_id"
    t.integer "student_id"
    t.index ["student_id"], name: "index_availabilities_on_student_id", using: :btree
    t.index ["teacher_id"], name: "index_availabilities_on_teacher_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string  "first_name",                null: false
    t.string  "last_name",                 null: false
    t.string  "email",                     null: false
    t.string  "phone",                     null: false
    t.boolean "primary",    default: true
    t.integer "teacher_id"
    t.integer "admin_id"
    t.integer "family_id"
    t.index ["admin_id"], name: "index_contacts_on_admin_id", using: :btree
    t.index ["family_id"], name: "index_contacts_on_family_id", using: :btree
    t.index ["teacher_id"], name: "index_contacts_on_teacher_id", using: :btree
  end

  create_table "excused_absences", force: :cascade do |t|
    t.integer "count", null: false
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer  "student_id",                 null: false
    t.string   "instrument",                 null: false
    t.text     "notes"
    t.boolean  "completed",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["student_id"], name: "index_inquiries_on_student_id", using: :btree
  end

  create_table "instruments", force: :cascade do |t|
    t.string "name"
  end

  create_table "lessons", force: :cascade do |t|
    t.string  "day",                           null: false
    t.date    "start_date",                    null: false
    t.time    "start_time",                    null: false
    t.integer "duration",                      null: false
    t.integer "purchased",                     null: false
    t.integer "attended",          default: 0, null: false
    t.string  "instrument",                    null: false
    t.string  "tier_name",                     null: false
    t.integer "price",                         null: false
    t.integer "excused_remaining", default: 0, null: false
    t.integer "student_id",                    null: false
    t.integer "teacher_id",                    null: false
    t.integer "inquiry_id",                    null: false
    t.index ["inquiry_id"], name: "index_lessons_on_inquiry_id", using: :btree
    t.index ["student_id"], name: "index_lessons_on_student_id", using: :btree
    t.index ["teacher_id"], name: "index_lessons_on_teacher_id", using: :btree
  end

  create_table "missed_lessons", force: :cascade do |t|
    t.datetime "date",      null: false
    t.integer  "lesson_id", null: false
    t.integer  "reason_id", null: false
    t.index ["lesson_id"], name: "index_missed_lessons_on_lesson_id", using: :btree
    t.index ["reason_id"], name: "index_missed_lessons_on_reason_id", using: :btree
  end

  create_table "prices", force: :cascade do |t|
    t.string  "tier_name", null: false
    t.integer "duration",  null: false
    t.decimal "price",     null: false
  end

  create_table "reasons", force: :cascade do |t|
    t.string  "reason",                          null: false
    t.boolean "teacher_paid",    default: false
    t.boolean "student_charged", default: false
  end

  create_table "students", force: :cascade do |t|
    t.string  "first_name", null: false
    t.string  "last_name",  null: false
    t.string  "school"
    t.date    "dob",        null: false
    t.integer "family_id"
    t.index ["family_id"], name: "index_students_on_family_id", using: :btree
  end

  create_table "teacher_instruments", force: :cascade do |t|
    t.integer "teacher_id"
    t.integer "instrument_id"
    t.index ["instrument_id"], name: "index_teacher_instruments_on_instrument_id", using: :btree
    t.index ["teacher_id"], name: "index_teacher_instruments_on_teacher_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",     default: "0.0", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "type"
    t.integer  "family_id"
    t.integer  "admin_id"
    t.index ["admin_id"], name: "index_transactions_on_admin_id", using: :btree
    t.index ["family_id"], name: "index_transactions_on_family_id", using: :btree
  end

end
