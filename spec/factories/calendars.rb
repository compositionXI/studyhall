# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :calendar do
      gmail_address "MyString"
      gmail_password "MyString"
      schedule_id 1
    end
end