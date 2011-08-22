class CreateExtracurriculars < ActiveRecord::Migration
  def up
    create_table :extracurriculars do |t|
      t.string :name
      t.string :type
      t.timestamps
    end
  end
  def down
    drop_table :extracurriculars
  end
end
