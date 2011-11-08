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

ActiveRecord::Schema.define(:version => 20111108041733) do

  create_table "activity_messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company_name"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_offering_imports", :force => true do |t|
    t.string   "course_offering_import_file_name"
    t.string   "course_offering_import_content_type"
    t.string   "course_offering_import_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "courses", :force => true do |t|
    t.string   "number"
    t.string   "title"
    t.integer  "school_id"
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
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

  create_table "followings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "followed_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "blocked",          :default => false
  end

  create_table "instructors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_copies", :force => true do |t|
    t.integer  "sent_messageable_id"
    t.string   "sent_messageable_type"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_updated_at"
    t.boolean  "spam",                    :default => false, :null => false
    t.boolean  "abuse",                   :default => false, :null => false
    t.integer  "parent_id"
    t.boolean  "opened",                  :default => false
    t.boolean  "deleted",                 :default => false
  end

  add_index "message_copies", ["sent_messageable_id", "recipient_id"], :name => "outbox_idx"

  create_table "messages", :force => true do |t|
    t.integer  "received_messageable_id"
    t.string   "received_messageable_type"
    t.integer  "sender_id"
    t.string   "subject"
    t.text     "body"
    t.boolean  "opened",                    :default => false
    t.boolean  "deleted",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_updated_at"
    t.boolean  "spam",                      :default => false, :null => false
    t.boolean  "abuse",                     :default => false, :null => false
    t.integer  "parent_id"
  end

  add_index "messages", ["received_messageable_id", "sender_id"], :name => "inbox_idx"

  create_table "notebooks", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.boolean  "shareable",  :default => true
  end

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "notebook_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shareable",   :default => true
  end

  create_table "offerings", :force => true do |t|
    t.integer  "course_id"
    t.string   "term"
    t.integer  "school_id"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "offering_id"
    t.text     "text"
    t.integer  "notebook_id"
    t.integer  "study_session_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.string   "upload_file_size"
    t.string   "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "reported"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rss_entries", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "pub_date"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rss_link"
    t.string   "domain_name"
    t.boolean  "active"
  end

  create_table "session_files", :force => true do |t|
    t.integer  "study_session_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "upload_uuid"
    t.string   "short_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_invites", :force => true do |t|
    t.integer "study_session_id"
    t.integer "user_id"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "study_sessions", :force => true do |t|
    t.string   "name"
    t.integer  "whiteboard_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tokbox_session_id"
    t.integer  "user_id"
    t.boolean  "shareable"
    t.integer  "offering_id"
  end

  create_table "users", :force => true do |t|
    t.string   "gender"
    t.integer  "school_id"
    t.string   "email"
    t.string   "major"
    t.decimal  "gpa",                  :precision => 4, :scale => 3
    t.string   "fraternity"
    t.string   "sorority"
    t.text     "extracurriculars"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "custom_url"
    t.text     "bio"
    t.boolean  "active",                                             :default => false, :null => false
    t.boolean  "shares_with_everyone",                               :default => true,  :null => false
    t.boolean  "googleable",                                         :default => true,  :null => false
    t.boolean  "notify_on_follow",                                   :default => true,  :null => false
    t.boolean  "notify_on_comment",                                  :default => true,  :null => false
    t.boolean  "notify_on_share",                                    :default => true,  :null => false
    t.boolean  "notify_on_invite",                                   :default => true,  :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
