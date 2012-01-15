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
  School.create(name: "Harvard University",     :domain_name => "harvard.edu", :active => true)
  School.create(name: "Yale University",        :domain_name => "yale.edu",    :active => true)
  School.create(name: "Cornell University",     :domain_name => "cornell.edu", :active => true)
  School.create(name: "University of Maryland", :domain_name => "umd.edu",     :active => false)
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


if User.count == 0
  ## Create Users
  User.create(
    first_name: "Peter",
    last_name: "Jackson",
    custom_url: "pete",
    gender: "Male",
    school: School.find_by_name('University of Maryland'),
    email: "pete@intridea.com",
    majors: [Major.find_by_name("Business School Student (MBA)")],
    gpa: 3.99,
    roles: [Role.find_by_name("Admin"), Role.find_by_name("Monitor"), Role.find_by_name("Student")],
    password: "1234",
    active: true,
    sports: [Sport.find_by_name('Mountaineering and Climbing')]
  )

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
    password: "studyh@ll",
    active: true
  )

  User.create(
    first_name: "Sam",
    last_name: "Grondahl",
    custom_url: "samg",
    gender: "Male",
    school: School.find_by_name('Yale University'),
    email: "sam@studyhall.com",
    majors: [Major.find_by_name("Economics")],
    gpa: 4.0,
    roles: [Role.find_by_name("Admin"), Role.find_by_name("Monitor"), Role.find_by_name("Student")],
    password: "studyh@ll",
    active: true
  )

  User.create(
    first_name: "Ben",
    last_name: "Winter",
    custom_url: "benw",
    gender: "Male",
    school: School.find_by_name('Cornell University'),
    email: "ben@studyhall.com",
    majors: [Major.find_by_name("Marketing")],
    gpa: 4.0,
    roles: [Role.find_by_name("Admin"), Role.find_by_name("Monitor"), Role.find_by_name("Student")],
    password: "studyh@ll",
    active: true
  )
end


