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

ActiveRecord::Schema.define(version: 20161206222347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       default: "Roberta"
    t.string   "email"
    t.string   "password",   default: "predo12345"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "information", force: :cascade do |t|
    t.string   "cep",        default: "0-0"
    t.string   "usuario",    default: "user"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "robot_logs", force: :cascade do |t|
    t.integer  "done_chat"
    t.integer  "fail_chat"
    t.string   "message"
    t.integer  "pulados",    default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "robot_id"
    t.index ["robot_id"], name: "index_robot_logs_on_robot_id", using: :btree
  end

  create_table "robots", force: :cascade do |t|
    t.string   "name"
    t.integer  "page_start"
    t.integer  "page_finish"
    t.boolean  "automatic",   default: false
    t.string   "search"
    t.boolean  "status"
    t.string   "nosearch",    default: ""
    t.integer  "page_number", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "type_id"
    t.index ["type_id"], name: "index_robots_on_type_id", using: :btree
  end

  create_table "types", force: :cascade do |t|
    t.string   "name"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "robot_logs", "robots"
  add_foreign_key "robots", "types"
end
