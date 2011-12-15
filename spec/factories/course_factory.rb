require 'factory_girl/syntax/sham'

Sham.title{|n| "class#{n}"}
Sham.department{|n| "deparement#{n}"}
Sham.number{|n| n}
Sham.school_id{|n| n}

FactoryGirl.define do
  factory :course do
    title { Sham.title }
    number {Sham.number}
    department { Sham.department }
    school {Factory.create(:school)}
  end
end
