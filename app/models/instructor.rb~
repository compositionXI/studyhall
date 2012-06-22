class Instructor < ActiveRecord::Base
  
  has_many :offerings
  
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => [:last_name]
  
  def full_name
    "#{self.last_name}, #{self.first_name}"
  end
end
