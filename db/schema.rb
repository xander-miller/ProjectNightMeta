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

ActiveRecord::Schema.define(version: 20131019201055) do

  create_table "accesses", force: true do |t|
    t.integer  "user_id",                           null: false
    t.string   "provider",       default: "meetup"
    t.integer  "uid",                               null: false
    t.string   "raw_name",                          null: false
    t.string   "raw_link"
    t.string   "raw_photo_link"
    t.string   "token"
    t.string   "refresh_token"
    t.integer  "expires_at"
    t.boolean  "expires",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accesses", ["provider"], name: "index_accesses_on_provider", using: :btree
  add_index "accesses", ["uid"], name: "index_accesses_on_uid", using: :btree
  add_index "accesses", ["user_id"], name: "index_accesses_on_user_id", using: :btree

  create_table "meetup_groups", force: true do |t|
    t.integer  "mu_id",             null: false
    t.string   "mu_name",           null: false
    t.string   "mu_link",           null: false
    t.string   "mu_photo_link"
    t.string   "mu_highres_link"
    t.string   "mu_thumb_link"
    t.integer  "mu_photo_id"
    t.integer  "mu_organizer_id"
    t.string   "mu_organizer_name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "description"
    t.string   "urlname"
    t.string   "visibility"
    t.string   "who"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meetup_groups", ["city"], name: "index_meetup_groups_on_city", using: :btree
  add_index "meetup_groups", ["mu_id"], name: "index_meetup_groups_on_mu_id", using: :btree
  add_index "meetup_groups", ["mu_name"], name: "index_meetup_groups_on_mu_name", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "github_id"
    t.boolean  "private",     default: false
    t.boolean  "fork",        default: false
    t.string   "name"
    t.string   "full_name",                   null: false
    t.string   "description"
    t.string   "language"
    t.string   "homepage"
    t.string   "html_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "user_id",     default: 0,     null: false
    t.boolean  "visible",     default: false
    t.string   "city"
    t.string   "country"
    t.string   "state",       default: "ON"
  end

  add_index "projects", ["city"], name: "index_projects_on_city", using: :btree
  add_index "projects", ["full_name"], name: "index_projects_on_full_name", using: :btree
  add_index "projects", ["language"], name: "index_projects_on_language", using: :btree
  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree
  add_index "projects", ["visible"], name: "index_projects_on_visible", using: :btree

  create_table "user_groups", force: true do |t|
    t.integer  "user_mu_id",                 null: false
    t.integer  "group_mu_id",                null: false
    t.boolean  "show",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["group_mu_id"], name: "index_user_groups_on_group_mu_id", using: :btree
  add_index "user_groups", ["user_mu_id"], name: "index_user_groups_on_user_mu_id", using: :btree

  create_table "user_projects", force: true do |t|
    t.integer  "user_id",                       null: false
    t.integer  "project_id",                    null: false
    t.boolean  "is_maintainer", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_projects", ["project_id"], name: "index_user_projects_on_project_id", using: :btree
  add_index "user_projects", ["user_id"], name: "index_user_projects_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                default: "",       null: false
    t.integer  "sign_in_count",        default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",             default: "meetup"
    t.integer  "uid",                                     null: false
    t.string   "mu_name",                                 null: false
    t.string   "mu_link",                                 null: false
    t.string   "authentication_token"
    t.string   "mu_refresh_token"
    t.integer  "mu_expires_at"
    t.boolean  "mu_expires",           default: true
    t.string   "mu_photo_link"
    t.string   "mu_highres_link"
    t.string   "mu_thumb_link"
    t.integer  "mu_photo_id"
    t.string   "city"
    t.string   "country"
    t.string   "state",                default: "ON"
  end

  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
