class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
end
