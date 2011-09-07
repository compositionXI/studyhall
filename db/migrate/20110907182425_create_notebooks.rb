class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.integer :user_id
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
