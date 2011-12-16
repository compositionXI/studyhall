require 'factory_girl/syntax/sham'

FactoryGirl.define do
  factory :course do
    sequence(:title) { |n| "Course #{n}" }
    sequence(:number) { |n| n }
    sequence(:department) { |n| "Department #{n}" }
    association :school
  end
end
