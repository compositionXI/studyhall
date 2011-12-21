class CreateMajorsSportsFratSororities < ActiveRecord::Migration
  def change
    create_table :sports, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :majors, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :frat_sororities, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end
end