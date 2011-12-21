class AddUsersSportsMajorsFratSororities < ActiveRecord::Migration
  def change
    create_table :sports_users, :id => false do |t|
      t.integer :user_id
      t.integer :sport_id
      t.timestamps
    end
    
    create_table :majors_users, :id => false do |t|
      t.integer :user_id
      t.integer :major_id
      t.timestamps
    end
    
    create_table :frat_sororities_users, :id => false do |t|
      t.integer :user_id
      t.integer :frat_sorority_id
      t.timestamps
    end
  end
end