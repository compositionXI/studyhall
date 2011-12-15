require 'factory_girl/syntax/sham'

Sham.email{|n| "somebody#{n}@email.com"}
Sham.custom_url{|n| "somebody#{n}"}

FactoryGirl.define do
  factory :user do
    email { Sham.email }
    password '1234'
    custom_url { Sham.custom_url }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    major { Faker::Lorem.words }
  end
end
