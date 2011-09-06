class CreateStudySessions < ActiveRecord::Migration
  def up
    create_table :study_sessions do |t|
      t.string :name
      t.integer :whiteboard_id
      t.integer :room_id
      t.timestamps
    end
  end
  
  def down
    drop_table :study_sessions
  end
end
