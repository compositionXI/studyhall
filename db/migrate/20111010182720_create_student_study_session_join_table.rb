class CreateStudentStudySessionJoinTable < ActiveRecord::Migration
  def up
    create_table :session_invites do |t|
      t.integer :study_session_id
      t.integer :user_id
    end
    add_column :study_sessions, :user_id, :integer
  end

  def down
    drop_table :session_invites
    remove_column :study_sessions, :user_id
  end
end
