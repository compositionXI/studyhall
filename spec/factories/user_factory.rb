require 'factory_girl/syntax/sham'

Sham.email{|n| "somebody#{n}@email.com"}
Sham.custom_url{|n| "somebody#{n}"}

FactoryGirl.define do
  factory :user do
    email { Sham.email }
    password '1234'
    custom_url { Sham.custom_url }
  end
end
