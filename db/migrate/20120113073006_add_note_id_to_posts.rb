class AddNoteIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :note_id, :integer
    add_index :posts, :note_id
  end
end
