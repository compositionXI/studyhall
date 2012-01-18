class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :number
      t.string :title
      t.integer :school_id
      t.string :department

      t.timestamps
    end
  end
end
