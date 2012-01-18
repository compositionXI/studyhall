FactoryGirl.define do
  factory :school do
    sequence(:name) { |n| "School #{n}" }
    sequence(:domain_name) { |n| "school#{n}.edu" }
  end
end
