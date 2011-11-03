class CourseOfferingImport < ActiveRecord::Base
  belongs_to :school 
  has_attached_file :course_offering_import
end
