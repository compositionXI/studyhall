class AddStateToCourseOfferingImports < ActiveRecord::Migration
  def change
    add_column :course_offering_imports, :state, :string
  end
end
