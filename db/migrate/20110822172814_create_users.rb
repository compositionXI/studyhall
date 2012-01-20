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
	User.create(
	    first_name: "Ross",
	    last_name: "Blankenship",
	    custom_url: "rossb",
	    gender: "Male",
	    school: School.find_by_name('Cornell University'),
	    email: "ross@studyhall.com",
	    majors: [Major.find_by_name("Government")],
	    gpa: 4.0,
	    roles: [Role.find_by_name("Admin"), Role.find_by_name("Monitor"), Role.find_by_name("Student")],
	    password: "studyhall",
	    active: true
	  )
  end
  
  def down
    drop_table :users
  end
end
