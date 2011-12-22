FactoryGirl.define do
  factory :course_offering_import do
    state :pending
    association :school
  end
end
