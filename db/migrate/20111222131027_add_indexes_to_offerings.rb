class AddIndexesToOfferings < ActiveRecord::Migration
  def change
    add_index :offerings, :school_id
    add_index :offerings, :course_id
    add_index :offerings, :term
    add_index :offerings, :instructor_id
  end
end
