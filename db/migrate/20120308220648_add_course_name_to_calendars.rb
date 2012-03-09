class AddCourseNameToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :course_name, :string

  end
end
