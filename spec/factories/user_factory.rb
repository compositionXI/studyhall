require 'factory_girl/syntax/sham'

Sham.email{|n| "somebody#{n}@email.com"}

FactoryGirl.define do
  factory :user do
    email { Sham.email }
    password '1234'
    sequence(:custom_url) { |n| "somebody#{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    major { Faker::Lorem.words }
    association :school
  end
end
