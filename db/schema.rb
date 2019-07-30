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

ActiveRecord::Schema.define(version: 20190729123459) do

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

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.integer  "blockable_id",               null: false
    t.string   "identifier",     limit: 255, null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "blockable_type"
    t.index ["blockable_id", "identifier"], name: "index_comfy_cms_blocks_on_blockable_id_and_identifier", using: :btree
    t.index ["blockable_type"], name: "index_comfy_cms_blocks_on_blockable_type", using: :btree
  end

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",                      null: false
    t.string  "label",            limit: 255, null: false
    t.string  "categorized_type", limit: 255, null: false
    t.index ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree
  end

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",                  null: false
    t.string  "categorized_type", limit: 255, null: false
    t.integer "categorized_id",               null: false
    t.index ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree
  end

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",             limit: 255,              null: false
    t.string   "file_file_name",    limit: 255,              null: false
    t.string   "file_content_type", limit: 255,              null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
    t.index ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
    t.index ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
    t.index ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree
  end

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",                                null: false
    t.integer  "parent_id"
    t.string   "app_layout", limit: 255
    t.string   "label",      limit: 255,                 null: false
    t.string   "identifier", limit: 255,                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",               default: 0,     null: false
    t.boolean  "is_shared",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
    t.index ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree
  end

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",          limit: 255,                 null: false
    t.string   "slug",           limit: 255
    t.string   "full_path",      limit: 255,                 null: false
    t.text     "content_cache"
    t.integer  "position",                   default: 0,     null: false
    t.integer  "children_count",             default: 0,     null: false
    t.boolean  "is_published",               default: true,  null: false
    t.boolean  "is_shared",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
    t.index ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree
  end

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", limit: 255, null: false
    t.integer  "record_id",               null: false
    t.text     "data"
    t.datetime "created_at"
    t.index ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_record_type_id_created", using: :btree
  end

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",       limit: 255,                 null: false
    t.string  "identifier",  limit: 255,                 null: false
    t.string  "hostname",    limit: 255,                 null: false
    t.string  "path",        limit: 255
    t.string  "locale",      limit: 255, default: "en",  null: false
    t.boolean "is_mirrored",             default: false, null: false
    t.index ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
    t.index ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree
  end

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",                                null: false
    t.string   "label",      limit: 255,                 null: false
    t.string   "identifier", limit: 255,                 null: false
    t.text     "content"
    t.integer  "position",               default: 0,     null: false
    t.boolean  "is_shared",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
    t.index ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree
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
