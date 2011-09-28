class User < ActiveRecord::Base
  acts_as_authentic
  has_mailbox

  has_and_belongs_to_many :extracurriculars
  has_and_belongs_to_many :roles
  has_attached_file :avatar, :styles => {:large => "400X400>", :medium => "50x50#", :thumb => "25x25#" }, :default_url => "/assets/generic_avatar_thumb.png"
  has_many :notebooks
  has_many :notes
  has_many :enrollments
  has_many :offerings, :through => :enrollments
  
  validates_presence_of :name

  PROTECTED_PROFILE_ATTRBUTES = %w(email)
  
  def has_role?(role)
    self.roles.include? role
  end
  
  def admin?
    self.roles.include?(Role.find_by_name "Admin")
  end
  
  def editable_by?(user)
    (self == user) || (user.roles.include?(Role.find_by_name "Admin"))
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
  
  def male?
    self.gender == "Male"
  end
  
  def female?
    self.gender == "Female"
  end
end
