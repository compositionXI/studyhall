class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.integer :course_id
      t.string :term
      t.integer :school_id
      t.integer :instructor_id

      t.timestamps
    end
  end
end
