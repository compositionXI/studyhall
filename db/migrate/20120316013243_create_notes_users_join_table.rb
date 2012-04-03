class CreateNotesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :notes_users, :id => false do |t|
      t.integer :note_id
      t.integer :user_id
    end
  end
end
