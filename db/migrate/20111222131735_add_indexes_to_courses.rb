class AddIndexesToCourses < ActiveRecord::Migration
  def change
    add_index :courses, :title
    add_index :courses, :school_id
    add_index :courses, :number
  end
end
