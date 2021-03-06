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

ActiveRecord::Schema.define(version: 2019_07_02_061646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenge_finalizations", id: :serial, force: :cascade do |t|
    t.integer "number_guessed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "odds_are_id"
  end

  create_table "challenge_requests", id: :serial, force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "acted_upon_at"
    t.integer "notification_id"
    t.integer "odds_are_id"
    t.index ["odds_are_id"], name: "index_challenge_requests_on_odds_are_id"
  end

  create_table "challenge_responses", id: :serial, force: :cascade do |t|
    t.integer "odds_out_of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "acted_upon_at"
    t.integer "number_chosen"
    t.integer "odds_are_id"
  end

  create_table "friend_requests", id: :serial, force: :cascade do |t|
    t.integer "target_user_id"
    t.integer "acting_user_id"
    t.datetime "acted_upon_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "friendships", id: :serial, force: :cascade do |t|
    t.string "friendable_type"
    t.integer "friendable_id"
    t.integer "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blocker_id"
    t.integer "status"
    t.index ["friendable_type", "friendable_id"], name: "index_friendships_on_friendable_type_and_friendable_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "clicked_at"
    t.datetime "acted_upon_at"
    t.integer "dismiss_type"
  end

  create_table "odds_ares", id: :serial, force: :cascade do |t|
    t.integer "initiator_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "challenge_request_id"
    t.datetime "responded_to_at"
    t.datetime "finalized_at"
    t.integer "task_id"
    t.index ["challenge_request_id"], name: "index_odds_ares_on_challenge_request_id"
    t.index ["initiator_id"], name: "index_odds_ares_on_initiator_id"
    t.index ["recipient_id"], name: "index_odds_ares_on_recipient_id"
    t.index ["task_id"], name: "index_odds_ares_on_task_id"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "winner_id"
    t.integer "loser_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "odds_are_id"
    t.datetime "loser_marked_completed_at"
    t.datetime "winner_marked_completed_at"
    t.index ["odds_are_id"], name: "index_tasks_on_odds_are_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.string "first_name"
    t.string "last_name"
    t.string "slug"
    t.string "auth_token"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "challenge_requests", "odds_ares"
  add_foreign_key "odds_ares", "challenge_requests"
end
