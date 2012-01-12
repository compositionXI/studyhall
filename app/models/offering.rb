class Offering < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, :use => :slugged
  
  belongs_to :course
  belongs_to :school
  belongs_to :instructor
  has_many :enrollments
  has_many :users, :through => :enrollments
  has_many :notes, :through => :users
  has_many :posts
  has_many :study_sessions
  
  validates_uniqueness_of :course_id, :scope => [:term, :instructor_id]
  
  def course_listing
    Rails.cache.fetch("course-listing-#{course.updated_at.to_i}-#{instructor.try(:updated_at).to_i}") do
      items = []
      items << self.course.department
      items << self.course.number
      items << self.course.title
      items << self.instructor.try(:full_name)
      items.compact.join(" - ")
    end
  end
  
  def classmates(current_user, count = nil)
    self.users.where("email != ?", current_user.email).order("first_name ASC, last_name ASC").limit(count)
  end

  def name
    course.title
  end

  def permalink
    "#{course.number} #{course.title} #{instructor.try(:full_name)}"
  end
end
