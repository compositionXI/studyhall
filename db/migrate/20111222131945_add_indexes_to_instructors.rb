class AddIndexesToInstructors < ActiveRecord::Migration
  def change
    add_index :instructors, :first_name
    add_index :instructors, :last_name
  end
end
