class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :gender
      t.string :school
      t.string :email, :null => false
      t.string :major
      t.decimal :gpa
      t.string :fraternity
      t.string :sorority
      t.text :extracurriculars
      
      t.string    :login,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :perishable_token,    :null => false

      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end