class Notebook < ActiveRecord::Base
  
  include Ownable

  belongs_to :course
  has_many :notes, :dependent => :destroy
  has_many :post, :dependent => :destroy
  
  scope :for_course, lambda {|course| where("course_id = ?", course.id) }

  def course_name
    course.title if course
  end

end
