class CreatePocStudySessions < ActiveRecord::Migration
  def up
    create_table :poc_study_sessions do |t|
      t.string :name
      t.integer :poc_whiteboard_id
      t.integer :poc_room_id
      t.timestamps
    end
  end
  
  def down
    drop_table :poc_study_sessions
  end
end
