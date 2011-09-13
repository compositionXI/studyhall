class Offering < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :school
  belongs_to :instructor
  belongs_to :term
  has_many :enrollments
  has_many :users, :through => :enrollments
  
  validates_uniqueness_of :course_id, :scope => [:section]
end
