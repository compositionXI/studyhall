class ChangeFieldsOnCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :days, :string
    add_column :calendars, :course_id, :int
    remove_column :calendars, :date_end
    remove_column :calendars, :gmail_address
    remove_column :calendars, :gmail_password
  end
end
