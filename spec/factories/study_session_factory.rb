FactoryGirl.define do
  factory :study_session do
    sequence(:name) { |n| "School #{n}" }
    association :user
    association :offering
  end
end