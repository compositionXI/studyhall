# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create Test Users
User.create(
  name: "Joe Smith",
  gender: "Male",
  school: "Central University",
  email: "Joe@email.com",
  major: "Electrical Engineering",
  gpa: 3.7,
  fraternity: "Delta Kappa Epsilon",
  login: "jsmith",
  role: "Admin",
  password: "1234",
  password_confirmation: "1234"
)

User.create(
  name: "Jane Doe",
  gender: "Female",
  school: "Harvard University",
  email: "Jane@email.com",
  major: "Psychology",
  gpa: 3.9,
  sorority: "Kappa Kappa Gamma",
  login: "jdoe",
  role: "Student",
  password: "1234",
  password_confirmation: "1234"
)

# Create About and FAQs static pages
StaticPage.create(
  title: "About",
  text: "Welcome to StudyHall.com! Where studying is social.\n Please take a moment to create a profile and look around.",
  slug: "about-us"
)

StaticPage.create(
  title: "FAQs",
  text: "What is the most awesome thing about StudyHall.com \nIt's social!",
  slug: "about-us"
)

# Create Test Contact
Contact.create(
  name: "Bob",
  email: "bob@email.com",
  company_name: "Bob's Business",
  phone: "555 123 1234",
  message: "This is a greate website!",
)
