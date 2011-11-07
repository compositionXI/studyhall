class Notebook < ActiveRecord::Base
  
  include Ownable

  belongs_to :course
  has_many :notes, :dependent => :destroy
  has_many :post, :dependent => :destroy

  def course_name
    course.title if course
  end

end
