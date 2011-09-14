class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
  
  validates_uniqueness_of :title, :scope => [:school_id, :number]
end
