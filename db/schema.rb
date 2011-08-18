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

ActiveRecord::Schema.define(:version => 20110817161459) do
ActiveRecord::Schema.define(:version => 20110815212245) do

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

end
