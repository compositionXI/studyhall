class AddCalendarIdToStudySessions < ActiveRecord::Migration
  def change
    add_column :study_sessions, :calendar_id, :integer

  end
end
