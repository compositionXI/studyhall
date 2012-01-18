FactoryGirl.define do
  factory :offering do
    association :school
    association :course
  end
end
