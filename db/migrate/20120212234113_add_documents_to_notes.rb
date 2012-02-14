class AddDocumentsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :doc_type,         :string
    add_column :notes, :doc_format,       :string
    add_column :notes, :doc_preserved,    :boolean
    add_column :notes, :doc_file_name,    :string
    add_column :notes, :doc_content_type, :string
    add_column :notes, :doc_file_size,    :integer
    add_column :notes, :doc_updated_at,   :datetime
  end
end
