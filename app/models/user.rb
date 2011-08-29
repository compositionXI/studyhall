class User < ActiveRecord::Base
  acts_as_authentic
    
  has_and_belongs_to_many :extracurriculars
  
  validates_presence_of :name
  
  def has_role?(role)
    self.role == role
  end
  
  def admin?
    self.role == "Admin"
  end
  
  def editable_by?(user)
    (self == user) || (user.role == "Admin")
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions(self)
  end
end