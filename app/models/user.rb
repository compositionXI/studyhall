class User < ActiveRecord::Base
  acts_as_authentic
    
  has_and_belongs_to_many :extracurriculars
  has_and_belongs_to_many :roles
  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "40x40#" }, :default_url => "/assets/generic_avatar_thumb.png"
  has_many :notebooks
  has_many :notes
  
  validates_presence_of :name
  
  def has_role?(role)
    self.roles.include? role
  end
  
  def admin?
    self.roles.include? Role.all.first
  end
  
  def editable_by?(user)
    (self == user) || (user.roles.include? Role.all.first)
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions(self)
  end
  
  def avatar_url(size = nil)
    self.avatar.url(size)
  end
  
  def has_avatar?
    self.avatar_file_name
  end
end
