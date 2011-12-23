FactoryGirl.define do
  factory :note do
    sequence(:name) {|n| "Note #{n}" }
  end
end
