class CourseOfferingImport < ActiveRecord::Base
  
  belongs_to :school
  belongs_to :term
  has_attached_file :course_offering_import
end
