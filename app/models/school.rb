class School < ActiveRecord::Base
  
  has_many :courses
  has_many :terms
  has_many :offerings
  has_many :course_offering_imports
  
  has_attached_file :import_file
  
  validates_uniqueness_of :name 
  
end
