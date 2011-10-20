class User < ActiveRecord::Base

  acts_as_authentic
  acts_as_voter
  acts_as_voteable
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
  has_many :authentications, :dependent => :destroy
  has_many :session_invites
  has_many :study_sessions, :through => :session_invites
  has_many :posts

  scope :other_than, lambda {|users| where(User.arel_table[:id].not_in(users.any? ? users.map(&:id) : [0])) }
  scope :with_attribute, lambda {|member| all.collect{|u| u unless u.send(member).nil? || u.send(member).blank? }.compact}

  validates_presence_of :name

  PROTECTED_PROFILE_ATTRBUTES = %w(email)

  def first_name
    @first_name ||= name.split(" ").first
  end

  def voted_for?(user)
    vote = user.votes.where(:voter_id => self).first
    vote.nil? ? false : vote.vote
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
  def follow!(user, attributes = {})
    attributes[:followed_user_id] = user.id
    followings.create(attributes)
  end

  #find the following object joining this user and the given user
  def following_for(user)
    followings.where(:followed_user_id => user.id).first
  end
  
  def block!(user)
    following = Following.where( :user_id => self.id, :followed_user_id => user.id).first
    if following.nil?
      follow!(user, :blocked => true)
    else
      following.update_attributes :blocked => true
    end
  end
  
  def blocked?(user)
    following = Following.where( :user_id => self.id, :followed_user_id => user.id).first
    following.blocked? unless following.nil?
  end
  
  def unblock!(user)
    following = Following.where :user_id => self.id, :followed_user_id => user.id
    following.first.update_attributes :blocked => false
  end
  
  def blocked_users
    User.find followings.blocked.collect { |f| f.followed_user_id }
  end

  def buddies
    followed_users - blocked_users
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

  def activate!
    self.active = true
    save
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions(self).deliver
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.welcome(self).deliver
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
  
  # TODO: Evaluate for refactor
  def split_attribute_list(attributes, model, collection_method)
    ids = []
    return ids if (attributes.blank? or attributes.empty?)
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
  
  def profile_completion_percentage
    count = 0.0
    total = 0.0
    [self.avatar_url, self.bio, self.custom_url, self.school_id, self.major, self.enrollments, self.gpa, self.gender, self.extracurriculars].each do |member|
      count += 1 unless member.nil? || member == "/assets/generic_avatar_thumb.png" || member == [] || member == ""
      total += 1
    end
    (count/total * 100).to_i
  end
  
  def profile_complete?
    self.profile_completion_percentage >= 100
  end
  
  def extracurriculars_list
    self.extracurriculars.collect {|e| e.name}.join(",")
  end
end

class User::NotAuthorized < StandardError; end
