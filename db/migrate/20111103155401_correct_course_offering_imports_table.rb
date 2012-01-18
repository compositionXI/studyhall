class CorrectCourseOfferingImportsTable < ActiveRecord::Migration
    def change
      remove_column :course_offering_imports, :offerings_count
      remove_column :course_offering_imports, :courses_count
      remove_column :course_offering_imports, :schools_count
      add_column    :course_offering_imports, :school_id, :integer
    end
end
