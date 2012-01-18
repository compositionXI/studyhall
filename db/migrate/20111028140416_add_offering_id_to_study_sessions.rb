class AddOfferingIdToStudySessions < ActiveRecord::Migration
  def change
    add_column :study_sessions, :offering_id, :integer
  end
end
