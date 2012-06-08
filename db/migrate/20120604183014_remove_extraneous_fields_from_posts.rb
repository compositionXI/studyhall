class RemoveExtraneousFieldsFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :note_id
    remove_column :posts, :upload_updated_at
    remove_column :posts, :upload_file_size
    remove_column :posts, :upload_content_type
    remove_column :posts, :upload_file_name
    remove_column :posts, :study_session_id
    remove_column :posts, :notebook_id
  end

  def down
    add_column :posts, :note_id, :integer
    add_column :posts, :upload_updated_at
    add_column :posts, :upload_file_size
    add_column :posts, :upload_content_type
    add_column :posts, :upload_file_name
    add_column :posts, :study_session_id, :integer
    add_column :posts, :notebook_id, :integer
  end
end
