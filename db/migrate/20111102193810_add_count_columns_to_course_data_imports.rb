class AddCountColumnsToCourseDataImports < ActiveRecord::Migration
  def change
    %w{schools_count courses_count offerings_count}.each do |column|
      add_column :course_offering_imports, column, :integer
    end
  end
end
