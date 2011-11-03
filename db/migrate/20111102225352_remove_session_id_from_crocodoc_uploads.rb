class RemoveSessionIdFromCrocodocUploads < ActiveRecord::Migration
  def up
    remove_column :session_files, :session_identifier
  end

  def down
    add_column :session_files, :session_identifier, :string
  end
end
