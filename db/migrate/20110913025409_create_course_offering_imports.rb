class CreateCourseOfferingImports < ActiveRecord::Migration
  def change
    create_table :course_offering_imports do |t|
      t.integer :school_id
      t.integer :term_id
      t.string :course_offering_import_file_name
      t.string :course_offering_import_content_type
      t.string :course_offering_import_file_size

      t.timestamps
    end
  end
end
