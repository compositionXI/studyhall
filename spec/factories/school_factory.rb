require 'factory_girl/syntax/sham'

Sham.school_name{|n| "school#{n}"}
Sham.domain_name{|n| "#{n}@school.edu"}

FactoryGirl.define do
  factory :school do
    name {Sham.school_name}
    domain_name {Sham.domain_name}
  end
end
