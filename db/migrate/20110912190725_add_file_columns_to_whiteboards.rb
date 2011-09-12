class AddFileColumnsToWhiteboards < ActiveRecord::Migration
  def change
    add_column :whiteboards, :upload_file_name, :string
    add_column :whiteboards, :upload_content_type, :string
    add_column :whiteboards, :upload_file_size, :integer
    add_column :whiteboards, :upload_updated_at, :datetime
    add_column :whiteboards, :upload_uuid, :string
    add_column :whiteboards, :short_id, :string
    remove_column :whiteboards, :document_uuid
  end
end
