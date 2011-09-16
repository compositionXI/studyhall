class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
  
  validates_presence_of :title, :number, :school_id, :department
  validates_uniqueness_of :title, :scope => [:school_id, :number]
end
