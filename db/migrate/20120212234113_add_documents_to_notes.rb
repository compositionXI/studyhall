class AddDocumentsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :doc_type, :string

    add_column :notes, :doc_format, :string

  end
end
