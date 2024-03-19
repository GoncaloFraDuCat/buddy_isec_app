# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_19_170444) do
  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mentorship_request_id"
    t.index ["mentorship_request_id"], name: "index_chatrooms_on_mentorship_request_id"
  end

  create_table "mentors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentorship_requests", force: :cascade do |t|
    t.integer "mentor_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mentee_id"
    t.index ["mentor_id"], name: "index_mentorship_requests_on_mentor_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.integer "chatroom_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "student_id", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_of_study"
    t.integer "current_year"
    t.boolean "mentor"
    t.string "name"
    t.string "email"
    t.text "bio"
    t.index ["student_id"], name: "index_users_on_student_id", unique: true
  end

  add_foreign_key "mentorship_requests", "users", column: "mentee_id"
  add_foreign_key "mentorship_requests", "users", column: "mentor_id"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
end
