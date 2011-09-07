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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110912023801) do

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company_name"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extracurriculars", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extracurriculars_users", :id => false, :force => true do |t|
    t.integer "extracurricular_id"
    t.integer "user_id"
  end

  create_table "notebooks", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "notebook_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poc_notes", :force => true do |t|
    t.string   "name"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poc_study_sessions", :force => true do |t|
    t.string   "name"
    t.integer  "poc_whiteboard_id"
    t.integer  "poc_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poc_whiteboards", :force => true do |t|
    t.string  "session_identifier"
    t.boolean "chat_component"
    t.boolean "invite_component"
    t.boolean "profile_component"
    t.boolean "voice_component"
    t.boolean "etherpad_component"
    t.boolean "documents_component"
    t.boolean "images_component"
    t.boolean "bottomtray_component"
    t.boolean "email_component"
    t.boolean "widgets_component"
    t.boolean "math_component"
    t.boolean "custom_css"
    t.boolean "fadein_js"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.string   "sessionId"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "gender"
    t.string   "school"
    t.string   "email"
    t.string   "major"
    t.decimal  "gpa",                 :precision => 4, :scale => 3
    t.string   "fraternity"
    t.string   "sorority"
    t.text     "extracurriculars"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
