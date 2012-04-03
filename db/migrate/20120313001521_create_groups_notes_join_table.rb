class CreateGroupsNotesJoinTable < ActiveRecord::Migration
   def change
    create_table :groups_notes, :id => false do |t|
      t.integer :group_id
      t.integer :note_id
    end
  end
end
