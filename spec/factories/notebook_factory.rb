require 'factory_girl/syntax/sham'

Sham.notebook_name{|n| "#{n}"}

FactoryGirl.define do
  factory :notebook do
    name { Sham.notebook_name }
    course {Factory.create(:course)}
  end
end
