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

ActiveRecord::Schema.define(version: 20170519143050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "chat_messages", id: :serial, force: :cascade do |t|
    t.string "message"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "point_id"
    t.index ["point_id"], name: "index_comments_on_point_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "media", id: :serial, force: :cascade do |t|
    t.integer "comment_id"
    t.integer "point_id"
    t.integer "user_id"
    t.binary "bin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_media_on_comment_id"
    t.index ["point_id"], name: "index_media_on_point_id"
    t.index ["user_id"], name: "index_media_on_user_id"
  end

  create_table "news", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "point_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "point_type"
    t.index ["point_id"], name: "index_news_on_point_id"
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "points", id: :serial, force: :cascade do |t|
    t.float "lng"
    t.float "lat"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "rating", default: 0
    t.string "point_type"
    t.boolean "isFulltime", default: true
    t.boolean "cardAccepted", default: false
    t.boolean "beer", default: true
    t.boolean "hard", default: true
    t.boolean "elite", default: false
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at", precision: 6
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "age"
    t.string "sex"
    t.string "comment"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "rated_points", id: :serial, force: :cascade do |t|
    t.boolean "direction"
    t.integer "user_id"
    t.integer "point_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["point_id"], name: "index_rated_points_on_point_id"
    t.index ["user_id"], name: "index_rated_points_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "json"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: 6
    t.datetime "invitation_sent_at", precision: 6
    t.datetime "invitation_accepted_at", precision: 6
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "points", name: "comments_point_id_fkey"
  add_foreign_key "comments", "users", name: "comments_user_id_fkey"
  add_foreign_key "media", "comments", name: "media_comment_id_fkey"
  add_foreign_key "media", "points", name: "media_point_id_fkey"
  add_foreign_key "media", "users", name: "media_user_id_fkey"
  add_foreign_key "news", "points", name: "news_point_id_fkey"
  add_foreign_key "news", "users", name: "news_user_id_fkey"
  add_foreign_key "points", "users", name: "points_user_id_fkey"
  add_foreign_key "profiles", "users", name: "profiles_user_id_fkey"
  add_foreign_key "rated_points", "points", name: "rated_points_point_id_fkey"
  add_foreign_key "rated_points", "users", name: "rated_points_user_id_fkey"
  add_foreign_key "settings", "users", name: "settings_user_id_fkey"
end
