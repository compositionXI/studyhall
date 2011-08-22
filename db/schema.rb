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

ActiveRecord::Schema.define(:version => 20110822175536) do

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
    t.integer  "max_participants"
    t.integer  "total_participants", :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "gender"
    t.string   "school"
    t.string   "email",                                            :null => false
    t.string   "major"
    t.decimal  "gpa",               :precision => 10, :scale => 0
    t.string   "fraternity"
    t.string   "sorority"
    t.text     "extracurriculars"
    t.string   "login",                                            :null => false
    t.string   "crypted_password",                                 :null => false
    t.string   "password_salt",                                    :null => false
    t.string   "persistence_token",                                :null => false
    t.string   "perishable_token",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
