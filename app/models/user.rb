class User < ActiveRecord::Base
  acts_as_authentic
    
  has_and_belongs_to_many :extracurriculars
  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40#" }, :default_url => "/assets/generic_avatar_thumb.png"
  
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
  
  def avatar_url(size = nil)
    self.avatar.url(size)
  end
end