class School < ActiveRecord::Base
  
  has_many :courses
  has_many :offerings
  has_many :course_offering_imports
  has_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name 
  
end
