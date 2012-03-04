class AddFieldsToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :user_id, :int
    add_column :calendars, :study_session_id, :int
    add_column :calendars, :date_start, :string
    add_column :calendars, :time_start, :string
    add_column :calendars, :date_end, :string
    add_column :calendars, :time_end, :string

  end
end
