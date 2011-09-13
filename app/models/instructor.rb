class Instructor < ActiveRecord::Base
  
  has_many :offerings
end
