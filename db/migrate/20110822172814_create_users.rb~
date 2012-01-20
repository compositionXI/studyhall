class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :gender
      t.string :school
      t.string :email
      t.string :major
      t.decimal :gpa, :precision => 4, :scale => 3
      t.string :fraternity
      t.string :sorority
      t.text :extracurriculars
      
      t.string    :login
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token
      t.string    :perishable_token

      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end