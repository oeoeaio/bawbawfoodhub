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

ActiveRecord::Schema.define(version: 20190731112503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",              limit: 255, default: "", null: false
    t.string   "encrypted_password", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
  end

  create_table "alerts", force: :cascade do |t|
    t.integer  "sensor_id",   null: false
    t.string   "category",    null: false
    t.datetime "sleep_until"
    t.datetime "resolved_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category"], name: "index_alerts_on_category", using: :btree
    t.index ["resolved_at"], name: "index_alerts_on_resolved_at", using: :btree
    t.index ["sensor_id"], name: "index_alerts_on_sensor_id", using: :btree
    t.index ["sleep_until"], name: "index_alerts_on_sleep_until", using: :btree
  end

  create_table "faq_groups", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.integer  "faq_group_id", null: false
    t.string   "question",     null: false
    t.text     "answer",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["faq_group_id"], name: "index_faqs_on_faq_group_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "slug",        null: false
    t.datetime "closes_at",   null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_jobs_on_slug", using: :btree
  end

  create_table "pack_days", force: :cascade do |t|
    t.integer  "season_id",  null: false
    t.date     "pack_date",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["season_id"], name: "index_pack_days_on_season_id", using: :btree
  end

  create_table "readings", force: :cascade do |t|
    t.integer  "sensor_id",   null: false
    t.decimal  "value",       null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["recorded_at"], name: "index_readings_on_recorded_at", using: :btree
    t.index ["sensor_id"], name: "index_readings_on_sensor_id", using: :btree
  end

  create_table "rollovers", force: :cascade do |t|
    t.integer  "season_id",                        null: false
    t.string   "confirmation_token",   limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cancelled_at"
    t.integer  "user_id",                          null: false
    t.string   "box_size",             limit: 255
    t.index ["confirmation_token"], name: "index_rollovers_on_confirmation_token", unique: true, using: :btree
    t.index ["season_id"], name: "index_rollovers_on_season_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "slug",             limit: 255
    t.boolean  "signups_open"
    t.integer  "places_remaining"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "starts_on"
    t.date     "ends_on"
    t.index ["slug"], name: "index_seasons_on_slug", unique: true, using: :btree
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name",                                                                 null: false
    t.boolean  "active"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.decimal  "lower_limit",                precision: 5, scale: 1, default: "0.0"
    t.decimal  "upper_limit",                precision: 5, scale: 1, default: "100.0"
    t.integer  "fail_count_for_value_alert",                         default: 1
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "season_id",                               null: false
    t.integer  "user_id",                                 null: false
    t.string   "box_size",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "frequency",                               null: false
    t.boolean  "delivery",                                null: false
    t.string   "street_address"
    t.string   "town"
    t.string   "postcode"
    t.index ["season_id"], name: "index_subscriptions_on_season_id", using: :btree
    t.index ["user_id", "season_id"], name: "index_subscriptions_on_user_id_and_season_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "given_name",             limit: 255, default: "", null: false
    t.string   "surname",                limit: 255, default: "", null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "phone",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "initialised_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
