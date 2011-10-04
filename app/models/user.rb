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
  belongs_to :school
  has_many :followings
  has_many :followed_users, :through => :followings
  
  validates_presence_of :name

  PROTECTED_PROFILE_ATTRBUTES = %w(email)

  def first_name
    @first_name ||= name.split(" ").first
  end

  def can_edit?(ownable)
    raise ArgumentError.new("User#can_edit? expects an object that includes the Ownable module") unless ownable.class.include?(Ownable)
    ownable.owner == self
  end

  #people the follow this user
  def followers
    User.where("users.id = followings.user_id AND followings.followed_user_id = ?",self.id).includes(:followings)
  end

  #does this person follow the give user?
  def follows?(user)
    followings.where(:followed_user_id => user.id).count > 0
  end

  #make this person follow the given user
  def follow!(user)
    followings.create(:followed_user_id => user.id)
  end

  #find the following object joining this user and the given user
  def following_for(user)
    followings.where(:followed_user_id => user.id).first
  end

  def buddies
    followed_users
  end
  
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
  
  def split_attribute_list(attributes, model, collection_method)
    ids = []
    attributes = attributes.split(",").delete_if {|a| a.strip! == ""}
    attributes.each do |a|
      new_record = model.new(name: a.strip)
      if new_record.save
        ids << new_record.id
      else
        ids << model.find_by_name(a.strip).id
      end
    end
    ids << self.send(collection_method)
    ids.flatten
  end
end
