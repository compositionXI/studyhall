# Load the rails application
require File.expand_path('../application', __FILE__)
require 'ownable'
require 'rails_admin'
# these are the recommendations from 
# http://docs.sendgrid.com/documentation/
# get-started/integrate/examples/
# rails-example-using-smtp/

ActionMailer::Base.smtp_settings = {
  :user_name => "studyhall",
  :password => "studyh@ll",
  :domain => "studyhall.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}


# Initialize the rails application
Studyhall::Application.initialize!

TYPEKIT_ID = 'vmy7sbk'
