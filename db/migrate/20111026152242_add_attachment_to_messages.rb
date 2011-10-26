class AddAttachmentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :attachment_file_name, :string
    add_column :messages, :attachment_content_type, :string
    add_column :messages, :attachment_file_size, :integer
    add_column :messages, :attachment_updated_at, :string
  end
end
