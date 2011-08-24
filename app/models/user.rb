class User < ActiveRecord::Base
  acts_as_authentic
    
  has_and_belongs_to_many :extracurriculars
  
  validates_presence_of :name
  
  def has_role?(role)
    self.role == role
  end
  
  def editable_by?(user)
    (self == user) || (user.role == "Admin")
  end
end