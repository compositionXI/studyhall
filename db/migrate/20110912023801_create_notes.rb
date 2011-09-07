class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.integer :user_id
      t.integer :notebook_id
      t.text :content

      t.timestamps
    end
  end
end
