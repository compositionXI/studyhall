class MergeRoomsAndWhiteboardsIntoStudySessions < ActiveRecord::Migration
  def up
    StudySession.delete_all

    drop_table :rooms
    drop_table :whiteboards

    create_table :session_files do |t|
      t.integer :study_session_id
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.timestamp :upload_updated_at
      t.string :session_identifier
      t.string :upload_uuid
      t.string :short_id
      t.timestamps
    end

    add_column :study_sessions, :tokbox_session_id, :string
  end

  def down
  end
end
