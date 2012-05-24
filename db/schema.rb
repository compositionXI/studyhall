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

ActiveRecord::Schema.define(:version => 20120506082159) do

  create_table "activity_messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "activist_id"
  end

  add_index "activity_messages", ["activist_id"], :name => "index_activity_messages_on_activist_id"
  add_index "activity_messages", ["user_id"], :name => "index_activity_messages_on_user_id"

  create_table "admins_groups", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "admins_groups", ["group_id"], :name => "index_admins_groups_on_group_id"
  add_index "admins_groups", ["user_id"], :name => "index_admins_groups_on_user_id"

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "broadcasts", :id => false, :force => true do |t|
    t.string  "user_id"
    t.string  "message"
    t.string  "intent"
    t.string  "args"
    t.boolean "current"
  end

  add_index "broadcasts", ["user_id"], :name => "index_broadcasts_on_user_id"

  create_table "calendars", :force => true do |t|
    t.integer  "schedule_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.integer  "study_session_id"
    t.string   "date_start"
    t.string   "time_start"
    t.string   "time_end"
    t.string   "days"
    t.integer  "course_id"
    t.string   "course_name"
  end

  add_index "calendars", ["course_id"], :name => "index_calendars_on_course_id"
  add_index "calendars", ["schedule_id"], :name => "index_calendars_on_schedule_id"
  add_index "calendars", ["study_session_id"], :name => "index_calendars_on_study_session_id"
  add_index "calendars", ["user_id"], :name => "index_calendars_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "school_name"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "course_offering_imports", :force => true do |t|
    t.string   "course_offering_import_file_name"
    t.string   "course_offering_import_content_type"
    t.string   "course_offering_import_file_size"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "school_id"
    t.string   "state"
  end

  add_index "course_offering_imports", ["school_id"], :name => "index_course_offering_imports_on_school_id"

  create_table "courses", :force => true do |t|
    t.string   "number"
    t.string   "title"
    t.integer  "school_id"
    t.string   "department"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "courses", ["number"], :name => "index_courses_on_number"
  add_index "courses", ["school_id"], :name => "index_courses_on_school_id"
  add_index "courses", ["title"], :name => "index_courses_on_title"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "enrollments", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "enrollments", ["offering_id"], :name => "index_enrollments_on_offering_id"
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "extracurriculars", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "extracurriculars_users", :id => false, :force => true do |t|
    t.integer "extracurricular_id"
    t.integer "user_id"
  end

  add_index "extracurriculars_users", ["extracurricular_id"], :name => "index_extracurriculars_users_on_extracurricular_id"
  add_index "extracurriculars_users", ["user_id"], :name => "index_extracurriculars_users_on_user_id"

  create_table "followings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "followed_user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "blocked",          :default => false
  end

  add_index "followings", ["followed_user_id"], :name => "index_followings_on_followed_user_id"
  add_index "followings", ["user_id"], :name => "index_followings_on_user_id"

  create_table "frat_sororities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "frat_sororities_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "frat_sorority_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "frat_sororities_users", ["frat_sorority_id"], :name => "index_frat_sororities_users_on_frat_sorority_id"
  add_index "frat_sororities_users", ["user_id"], :name => "index_frat_sororities_users_on_user_id"

  create_table "group_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "comment_id"
    t.string   "message"
    t.boolean  "root"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_posts", ["comment_id"], :name => "index_group_posts_on_comment_id"
  add_index "group_posts", ["group_id"], :name => "index_group_posts_on_group_id"
  add_index "group_posts", ["user_id"], :name => "index_group_posts_on_user_id"

  create_table "groups", :force => true do |t|
    t.integer  "owner_id"
    t.string   "bio"
    t.boolean  "active"
    t.string   "group_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin_approval"
    t.boolean  "privacy_open"
    t.boolean  "privacy_closed"
    t.boolean  "privacy_secret"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "groups", ["owner_id"], :name => "index_groups_on_owner_id"

  create_table "groups_notes", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "note_id"
  end

  add_index "groups_notes", ["group_id"], :name => "index_groups_notes_on_group_id"
  add_index "groups_notes", ["note_id"], :name => "index_groups_notes_on_note_id"

  create_table "instructors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "instructors", ["first_name"], :name => "index_instructors_on_first_name"
  add_index "instructors", ["last_name"], :name => "index_instructors_on_last_name"

  create_table "majors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "majors_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "major_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "majors_users", ["major_id"], :name => "index_majors_users_on_major_id"
  add_index "majors_users", ["user_id"], :name => "index_majors_users_on_user_id"

  create_table "member_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "answered"
    t.boolean  "accepted"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "member_requests", ["group_id"], :name => "index_member_requests_on_group_id"
  add_index "member_requests", ["user_id"], :name => "index_member_requests_on_user_id"

  create_table "members_groups", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "members_groups", ["group_id"], :name => "index_members_groups_on_group_id"
  add_index "members_groups", ["user_id"], :name => "index_members_groups_on_user_id"

  create_table "message_copies", :force => true do |t|
    t.integer  "sent_messageable_id"
    t.string   "sent_messageable_type"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
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
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
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
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "course_id"
    t.boolean  "shareable",  :default => true
  end

  add_index "notebooks", ["course_id"], :name => "index_notebooks_on_course_id"
  add_index "notebooks", ["user_id"], :name => "index_notebooks_on_user_id"

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "notebook_id"
    t.text     "content"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "shareable",        :default => true
    t.string   "doc_type"
    t.string   "doc_format"
    t.boolean  "doc_preserved"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.boolean  "private"
    t.boolean  "share_all"
    t.boolean  "share_school"
    t.boolean  "share_choice"
  end

  add_index "notes", ["notebook_id"], :name => "index_notes_on_notebook_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "notes_users", :id => false, :force => true do |t|
    t.integer "note_id"
    t.integer "user_id"
  end

  add_index "notes_users", ["note_id"], :name => "index_notes_users_on_note_id"
  add_index "notes_users", ["user_id"], :name => "index_notes_users_on_user_id"

  create_table "offerings", :force => true do |t|
    t.integer  "course_id"
    t.string   "term"
    t.integer  "school_id"
    t.integer  "instructor_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
  end

  add_index "offerings", ["course_id"], :name => "index_offerings_on_course_id"
  add_index "offerings", ["instructor_id"], :name => "index_offerings_on_instructor_id"
  add_index "offerings", ["school_id"], :name => "index_offerings_on_school_id"
  add_index "offerings", ["slug"], :name => "index_offerings_on_slug", :unique => true
  add_index "offerings", ["term"], :name => "index_offerings_on_term"

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
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "parent_id"
    t.boolean  "reported"
    t.integer  "note_id"
  end

  add_index "posts", ["note_id"], :name => "index_posts_on_note_id"
  add_index "posts", ["notebook_id"], :name => "index_posts_on_notebook_id"
  add_index "posts", ["offering_id"], :name => "index_posts_on_offering_id"
  add_index "posts", ["study_session_id"], :name => "index_posts_on_study_session_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.text     "conn_cda"
    t.text     "rank_cda"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommendations", ["school_id"], :name => "index_recommendations_on_school_id"
  add_index "recommendations", ["user_id"], :name => "index_recommendations_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rss_entries", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "pub_date"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "rss_link"
    t.string   "domain_name"
    t.boolean  "active"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.string   "keywords"
    t.text     "advanced_query"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "session_files", :force => true do |t|
    t.integer  "study_session_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "upload_uuid"
    t.string   "short_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "session_files", ["short_id"], :name => "index_session_files_on_short_id"
  add_index "session_files", ["study_session_id"], :name => "index_session_files_on_study_session_id"
  add_index "session_files", ["upload_uuid"], :name => "index_session_files_on_upload_uuid"

  create_table "session_invites", :force => true do |t|
    t.integer "study_session_id"
    t.integer "user_id"
  end

  add_index "session_invites", ["study_session_id"], :name => "index_session_invites_on_study_session_id"
  add_index "session_invites", ["user_id"], :name => "index_session_invites_on_user_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sports_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sports_users", ["sport_id"], :name => "index_sports_users_on_sport_id"
  add_index "sports_users", ["user_id"], :name => "index_sports_users_on_user_id"

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "study_sessions", :force => true do |t|
    t.string   "name"
    t.integer  "whiteboard_id"
    t.integer  "room_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "tokbox_session_id"
    t.integer  "user_id"
    t.boolean  "shareable"
    t.integer  "offering_id"
    t.string   "gmail_address"
    t.string   "gmail_password"
    t.string   "time_start"
    t.string   "time_end"
    t.boolean  "calendar"
    t.integer  "calendar_id"
  end

  add_index "study_sessions", ["calendar_id"], :name => "index_study_sessions_on_calendar_id"
  add_index "study_sessions", ["offering_id"], :name => "index_study_sessions_on_offering_id"
  add_index "study_sessions", ["room_id"], :name => "index_study_sessions_on_room_id"
  add_index "study_sessions", ["tokbox_session_id"], :name => "index_study_sessions_on_tokbox_session_id"
  add_index "study_sessions", ["user_id"], :name => "index_study_sessions_on_user_id"
  add_index "study_sessions", ["whiteboard_id"], :name => "index_study_sessions_on_whiteboard_id"

  create_table "textbooks", :force => true do |t|
    t.integer  "course_id"
    t.integer  "offering_id"
    t.text     "users_w_book"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "textbook_html"
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
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
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
    t.integer  "grad_year"
  end

  add_index "users", ["school_id"], :name => "index_users_on_school_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
