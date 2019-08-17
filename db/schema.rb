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

ActiveRecord::Schema.define(version: 2019_08_17_110415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "alerts", id: :serial, force: :cascade do |t|
    t.integer "sensor_id", null: false
    t.string "category", null: false
    t.datetime "sleep_until"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_alerts_on_category"
    t.index ["resolved_at"], name: "index_alerts_on_resolved_at"
    t.index ["sensor_id"], name: "index_alerts_on_sensor_id"
    t.index ["sleep_until"], name: "index_alerts_on_sleep_until"
  end

  create_table "faq_groups", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.integer "faq_group_id", null: false
    t.string "question", null: false
    t.text "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faq_group_id"], name: "index_faqs_on_faq_group_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.datetime "closes_at", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_jobs_on_slug"
  end

  create_table "pack_days", id: :serial, force: :cascade do |t|
    t.integer "season_id", null: false
    t.date "pack_date", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["season_id"], name: "index_pack_days_on_season_id"
  end

  create_table "readings", id: :serial, force: :cascade do |t|
    t.integer "sensor_id", null: false
    t.decimal "value", null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorded_at"], name: "index_readings_on_recorded_at"
    t.index ["sensor_id"], name: "index_readings_on_sensor_id"
  end

  create_table "rollovers", id: :serial, force: :cascade do |t|
    t.integer "season_id", null: false
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cancelled_at"
    t.integer "user_id", null: false
    t.string "box_size", limit: 255
    t.index ["confirmation_token"], name: "index_rollovers_on_confirmation_token", unique: true
    t.index ["season_id"], name: "index_rollovers_on_season_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "slug", limit: 255
    t.boolean "signups_open"
    t.integer "places_remaining"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "starts_on"
    t.date "ends_on"
    t.index ["slug"], name: "index_seasons_on_slug", unique: true
  end

  create_table "sensors", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "lower_limit", precision: 5, scale: 1, default: "0.0"
    t.decimal "upper_limit", precision: 5, scale: 1, default: "100.0"
    t.integer "fail_count_for_value_alert", default: 1
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "season_id", null: false
    t.integer "user_id", null: false
    t.string "box_size", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "frequency", null: false
    t.boolean "delivery", null: false
    t.string "street_address"
    t.string "town"
    t.string "postcode"
    t.index ["season_id"], name: "index_subscriptions_on_season_id"
    t.index ["user_id", "season_id"], name: "index_subscriptions_on_user_id_and_season_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "given_name", limit: 255, default: "", null: false
    t.string "surname", limit: 255, default: "", null: false
    t.string "email", limit: 255, default: "", null: false
    t.string "phone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "initialised_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
