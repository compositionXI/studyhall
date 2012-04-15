class AddIndexesToManyForeignKeys < ActiveRecord::Migration
  def change

  	add_index :activity_messages, :user_id
  	add_index :activity_messages, :activist_id

  	add_index :admins_groups, :user_id
  	add_index :admins_groups, :group_id

  	add_index :broadcasts, :user_id

  	add_index :calendars, :schedule_id
  	add_index :calendars, :user_id
  	add_index :calendars, :study_session_id
  	add_index :calendars, :course_id

  	add_index :course_offering_imports, :school_id

  	add_index :enrollments, :offering_id
  	add_index :enrollments, :user_id

  	add_index :extracurriculars_users, :extracurricular_id
  	add_index :extracurriculars_users, :user_id

  	add_index :followings, :followed_user_id
  	add_index :followings, :user_id

  	add_index :frat_sororities_users, :user_id
  	add_index :frat_sororities_users, :frat_sorority_id

		add_index :group_posts, :user_id
		add_index :group_posts, :group_id
		add_index :group_posts, :comment_id

		add_index :groups, :owner_id

		add_index :groups_notes, :group_id
		add_index :groups_notes, :note_id
	
		add_index :majors_users, :user_id
		add_index :majors_users, :major_id

		add_index :member_requests, :user_id
		add_index :member_requests, :group_id

		add_index :members_groups, :user_id
		add_index :members_groups, :group_id

		add_index :notebooks, :user_id
		add_index :notebooks, :course_id

		add_index :notes, :user_id
		add_index :notes, :notebook_id

		add_index :notes_users, :note_id
		add_index :notes_users, :user_id

		add_index :posts, :user_id
		add_index :posts, :offering_id
		add_index :posts, :notebook_id
		add_index :posts, :study_session_id

		add_index :recommendations, :user_id
		add_index :recommendations, :school_id

		add_index :roles_users, :role_id
		add_index :roles_users, :user_id

		add_index :searches, :user_id

		add_index :session_files, :study_session_id
		add_index :session_files, :short_id
		add_index :session_files, :upload_uuid

		add_index :session_invites, :study_session_id
		add_index :session_invites, :user_id

		add_index :sports_users, :user_id
		add_index :sports_users, :sport_id

		add_index :study_sessions, :whiteboard_id
		add_index :study_sessions, :room_id
		add_index :study_sessions, :tokbox_session_id
		add_index :study_sessions, :user_id
		add_index :study_sessions, :offering_id
		add_index :study_sessions, :calendar_id
		
		add_index :users, :school_id
  end
end
