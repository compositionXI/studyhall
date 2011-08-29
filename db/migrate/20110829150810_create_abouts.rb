class CreateAbouts < ActiveRecord::Migration
  def change
    create_table :abouts do |t|
      t.text :text
      t.boolean :display

      t.timestamps
    end
  end
end
