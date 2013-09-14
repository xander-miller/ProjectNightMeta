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

ActiveRecord::Schema.define(version: 20130914173856) do

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",               default: "meetup"
    t.integer  "uid",                                       null: false
    t.integer  "mu_id",                                     null: false
    t.string   "mu_name",                                   null: false
    t.string   "mu_link",                                   null: false
    t.string   "authentication_token"
    t.string   "mu_refresh_token"
    t.integer  "mu_expires_at"
    t.boolean  "mu_expires",             default: true
    t.string   "mu_photo_link"
    t.string   "mu_highres_link"
    t.string   "mu_thumb_link"
    t.integer  "mu_photo_id"
    t.string   "city"
    t.string   "country"
  end

  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["mu_id"], name: "index_users_on_mu_id", using: :btree
  add_index "users", ["mu_name"], name: "index_users_on_mu_name", using: :btree

end
