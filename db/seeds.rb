# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create User Roles
%w{Student Monitor Admin}.each do |role|
  Role.create(name: role)
end

##Create static pages
["Privacy Policy", "Terms Of Service", "About Us"].each do |title|
  page = StaticPage.find_by_title(title)
  page.destroy unless page.nil?
end

StaticPage.create(
  :title => "Privacy Policy",
  :slug => "privacy",
  :text => File.open("./public/static/privacy_policy.html", "r").read
)

StaticPage.create(
  :title => "Terms Of Service",
  :slug => "terms",
  :text => File.open("./public/static/terms_of_service.html", "r").read
)

StaticPage.create(
  :title => "About Us",
  :slug => "about",
  :text => File.open("./public/static/about_us.html", "r").read
)


##Create Schools
if School.all.empty?
  School.create(name: "Harvard University", :domain_name => "harvard.edu", :active => true)
end

## Create Test Users
User.create(
  first_name: "Joe",
  last_name: "Smith",
  custom_url: "joesmith",
  gender: "Male",
  school: School.first,
  email: "Joe@email.com",
  major: "Electrical Engineering",
  gpa: 3.7,
  fraternity: "Delta Kappa Epsilon",
  roles: [Role.find_by_name("Admin"), Role.find_by_name("Monitor"), Role.find_by_name("Student")],
  password: "1234",
  active: true
)
