FactoryGirl.define do
  factory :notebook do
    sequence(:name) {|n| "Notebook #{n}" }
    association :course
  end
end
