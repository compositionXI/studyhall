class Enrollment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :offering
  
  validates_uniqueness_of :offering_id, :scope => [:user_id]
  
end
