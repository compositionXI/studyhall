class Offering < ActiveRecord::Base
  
  belongs_to :course
  belongs_to :school
  belongs_to :instructor
  has_many :enrollments
  has_many :users, :through => :enrollments
  has_many :posts
  
  validates_uniqueness_of :course_id, :scope => [:term, :instructor_id]
  
  def course_listing
    "#{self.course.department} - #{self.course.number} - #{self.course.title} - #{self.instructor.full_name}"
  end
  
  def classmates(current_user)
    self.users.sort_by(&:name) - [current_user]
  end

  def name
    course.title
  end
end
