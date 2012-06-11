class CreateTextbooks < ActiveRecord::Migration
  def change
    create_table :textbooks do |t|
      t.integer :course_id
      t.integer :offering_id
      t.string :isbn
      t.text :users_w_book

      t.timestamps
    end
  end
end
