class AddGmailToStudySessions < ActiveRecord::Migration
  def change
    add_column :study_sessions, :gmail_address, :string

    add_column :study_sessions, :gmail_password, :string

    add_column :study_sessions, :time_start, :string

    add_column :study_sessions, :time_end, :string

    add_column :study_sessions, :calendar, :boolean

  end
end
