class User < ActiveRecord::Base
  has_and_belongs_to_many :extracurriculars
  
  validates_presence_of :name
end
