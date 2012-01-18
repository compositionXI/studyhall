class AddCourseIdToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :course_id, :integer
  end
end
