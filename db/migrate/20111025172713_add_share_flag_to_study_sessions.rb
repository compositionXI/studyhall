class AddShareFlagToStudySessions < ActiveRecord::Migration
  def change
    add_column :study_sessions, :shareable, :boolean
  end
end
