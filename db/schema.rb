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

ActiveRecord::Schema[7.1].define(version: 2024_08_21_055816) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_announcements_on_course_id"
  end

  create_table "course_dates", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "course_number", null: false
    t.string "course_date", null: false
    t.boolean "is_reflection", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "course_date"], name: "index_course_dates_on_course_id_and_course_date", unique: true
    t.index ["course_id", "course_number"], name: "index_course_dates_on_course_id_and_course_number", unique: true
    t.index ["course_id"], name: "index_course_dates_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "teacher_name", null: false
    t.string "day_of_week", null: false
    t.string "course_time", null: false
    t.string "uuid", null: false
    t.string "course_code", null: false
    t.bigint "created_by_id", null: false
    t.bigint "school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_courses_on_created_by_id"
    t.index ["name", "created_by_id"], name: "index_courses_on_name_and_created_by_id", unique: true
    t.index ["school_id", "course_code"], name: "index_courses_on_school_id_and_course_code", unique: true
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "prompt_questions", force: :cascade do |t|
    t.bigint "prompt_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id"], name: "index_prompt_questions_on_prompt_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "title", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_prompts_on_course_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.bigint "course_date_id", null: false
    t.string "message", null: false
    t.string "message_type", null: false
    t.float "message_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_date_id"], name: "index_reflections_on_course_date_id"
    t.index ["course_id"], name: "index_reflections_on_course_id"
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_schools_on_name", unique: true
  end

  create_table "user_courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id"
    t.index ["user_id"], name: "index_user_courses_on_user_id"
  end

  create_table "user_schools", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_user_schools_on_school_id"
    t.index ["user_id"], name: "index_user_schools_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.integer "user_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "announcements", "courses"
  add_foreign_key "course_dates", "courses"
  add_foreign_key "courses", "schools"
  add_foreign_key "courses", "users", column: "created_by_id"
  add_foreign_key "prompt_questions", "prompts"
  add_foreign_key "prompts", "courses"
  add_foreign_key "reflections", "course_dates"
  add_foreign_key "reflections", "courses"
  add_foreign_key "reflections", "users"
  add_foreign_key "user_courses", "courses"
  add_foreign_key "user_courses", "users"
  add_foreign_key "user_schools", "schools"
  add_foreign_key "user_schools", "users"
end
