# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create User Roles
if Role.count == 0
  %w{Student Monitor Admin}.each do |role|
    Role.create(name: role)
  end
end

if StaticPage.count == 0
  ##Create static pages
  ["Privacy Policy", "Terms Of Service", "About Us", "FAQ's"].each do |title|
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

  StaticPage.create(
    :title => "FAQ's",
    :slug => "faqs",
    :text => File.open("./public/static/faqs.html", "r").read
  )
end

##Create Schools
if School.all.empty?
  School.create(name: "Harvard University", :domain_name => "harvard.edu", :active => true)
end

if User.count == 0
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
end

if Sport.count == 0
  sports = YAML.load_file('db/data/sports.yml')
  sports.each do |sport_name|
    Sport.create(name: sport_name)
  end
end

if Major.count == 0
  majors = YAML.load_file('db/data/majors.yml')
  majors.each do |major_name|
    Major.create(name: major_name)
  end
end

if FratSorority.count == 0
  frat_sororities = YAML.load_file('db/data/frats_sororities.yml')
  frat_sororities.each do |name|
    FratSorority.create(name: name)
  end
end
