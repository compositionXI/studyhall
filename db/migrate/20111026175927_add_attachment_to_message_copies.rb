class AddAttachmentToMessageCopies < ActiveRecord::Migration
  def change
    add_column :message_copies, :attachment_file_name, :string
    add_column :message_copies, :attachment_content_type, :string
    add_column :message_copies, :attachment_file_size, :integer
    add_column :message_copies, :attachment_updated_at, :string
  end
end
