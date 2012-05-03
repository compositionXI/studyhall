class User < ActiveRecord::Base

  acts_as_authentic do |config|
    config.require_password_confirmation = false
    config.perishable_token_valid_for = 5.days
  end
  acts_as_voter
  acts_as_voteable
  has_mailbox

  has_attached_file :avatar, 
    :styles => {:large => "400X400>", :medium => "50x50#", :thumb => "25x25#" }, 
    :default_url => "/assets/generic_avatar_:style.png",
    :storage => :s3, 
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :bucket => "bucket_dev_sh0" # "studyhall#{Rails.env}"

  attr_accessor :delete_avatar
  before_post_process :paperclip_hack_filename

  has_and_belongs_to_many :extracurriculars
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :majors
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :frat_sororities
  has_and_belongs_to_many :groups, :join_table => :members_groups

  has_many :broadcasts
  has_many :recommendations
  has_many :notebooks
  has_many :notes
  has_many :enrollments
  has_many :offerings, :through => :enrollments
  has_many :courses, :through => :offerings
  belongs_to :school
  # attr_readonly :school_id
  has_many :followings
  has_many :followed_users, :through => :followings
  has_many :authentications, :dependent => :destroy
  has_many :session_invites
  has_many :study_sessions, :through => :session_invites
  has_many :posts
  has_many :activity_messages
  has_many :calendars
  
  has_many :searches
  
  scope :active_users, where(:active => true)

  scope :other_than, lambda {|users| where(User.arel_table[:id].not_in(users.any? ? users.map(&:id) : [0])) }
  scope :with_attribute, lambda {|member| all.collect{|u| u unless u.send(member).nil? || u.send(member).blank? }.compact}
  scope :has_extracurricular, lambda { |extracurricular_id| all.collect{|u| u if u.extracurricular_ids.include? extracurricular_id}}
  scope :has_frat_sororities, lambda { |frat_sorority_ids| joins("join frat_sororities_users on frat_sororities_users.user_id = users.id").where({ frat_sororities_users: { frat_sorority_id: frat_sorority_ids}})}
  scope :has_sports, lambda { |sports_ids| joins("join sports_users on sports_users.user_id = users.id").where({ sports_users: { sport_id: sports_ids}})}
  
  validates :custom_url, 
    :format => {:with => /^[a-z0-9]+[-a-z0-9]*[a-z0-9]+$/i, :message => "may only use letters and numbers."},
    :uniqueness => true  
  validates_numericality_of :gpa, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 4.0, :allow_nil => true
  validate :name_should_be_present
  validate :email_should_be_present
  validate :school_should_be_present
  
  before_validation do
    self.school = School.from_email self.email if self.email and self.school_id.nil?
    self.roles << Role.find_by_name("Student") if self.role_ids.nil?
  end
  validates_attachment_content_type :avatar, :content_type =>  ["image/jpeg", "image/jpg", "image/x-png", "image/pjpeg", "image/png", "image/gif"], :message => "Oops! Make sure you are uploading an image file." 
  validates_attachment_size :avatar, :less_than => 10.megabyte, :message => "Max Size of the image is 10M"
  
  after_create do
    Recommendation.populate_user([self.id])
  end

  searchable :auto_index => false, :auto_remove => true do
    text :name
    text :school_name
    text :course_names
    text :fraternity
    text :sorority
    text :extracurriculars
    text :major
    text :bio
    string :name
    integer :school_id
    integer :plusminus
    boolean :shares_with_everyone
    boolean :active
  end

  PROTECTED_PROFILE_ATTRBUTES = %w(email)

  def current_broadcasts
    Broadcast.where("user_id = ? AND current = ?", self.id, true)
  end

  def documents(type=nil)
    type ? Note.where("user_id = ? AND doc_type = ?", self.id, type) : self.notes
  end

  def name_should_be_present
    self.errors[:first_name] = "cannot be blank" if (first_name.blank? && read_attribute(:active) == true)
    self.errors[:last_name] = "cannot be blank" if (last_name.blank? && read_attribute(:active) == true)
  end
  
  def school_should_be_present
    self.errors[:school_id] = "No school was found with that email address." if (school_id.blank? && read_attribute(:active) == true)
  end
  
  def email_should_be_present
    self.errors[:email] = "cannot be blank" if (email.blank? && read_attribute(:active) == true)
  end

  def activity
    activity_messages.order('created_at DESC')
  end

  def photo_url(size = :medium)
    if avatar.file?
      avatar.url(size)
    else
      "/assets/generic_avatar_#{size.to_s}.png"
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def name
    full_name
  end
  
  def title_name
    name.titleize
  end
  
  def trunc_name(length, titleize=true)
    tname = titleize ? title_name : name
    tname.length > length ? "#{tname.slice(0, length)}..." : tname
  end
  
  def school_name
    school.try(:name)
  end
  
  def course_names
    courses.map(&:title).join(" ")
  end

  def voted_for?(user)
    vote = user.votes.where(:voter_id => self).first
    vote.nil? ? false : vote.vote
  end

  def can_edit?(ownable)
    raise ArgumentError.new("User#can_edit? expects an object that includes the Ownable module") unless ownable.class.include?(Ownable)
    ownable.owner == self
  end

  def can_view?(note)
    note.user_id == self.id || note.shareable
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
    attributes[:followed_user_id] = user.id if user
    followings.create(attributes)
  end

  def unfollow!(user, attributes = {})
    attributes[:followed_user_id] = user.id if user
    followings.where(attributes).delete_all
  end

  #find the following object joining this user and the given user
  def following_for(user)
    return nil unless user
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
    return false unless user
    following = Following.where( :user_id => self.id, :followed_user_id => user.id).first
    following.blocked? unless following.nil?
  end
  
  def unblock!(user)
    return unless user
    following = Following.where :user_id => self.id, :followed_user_id => user.id
    following.first.update_attributes :blocked => false
  end
  
  def blocked_users
    User.includes(:followings).where("followings.blocked = ?",true)
  end

  def buddies(count = nil)
    User.joins("INNER JOIN followings ON users.id = followings.followed_user_id").where("followings.user_id = ? and followings.blocked = ? ", self.id, false).limit(count).order("first_name ASC, last_name ASC")
  end

  def mutual?(user)
    user.follows(self)
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

  def added_course?(course)
    self.courses.where(id: course.id).any?
  end

  def activate!
    update_attribute(:active, true)
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

  def deliver_followed_notification!(follower)
    Notifier.user_following(follower,self).deliver
  end
  
  def avatar_url(size = nil)
    photo_url(size)
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
    [self.first_name, self.last_name, self.photo_url, self.bio, self.custom_url, self.school_id, self.majors, self.gpa, self.gender, self.sports, self.frat_sororities].each do |member|
      count += 1 unless (member.blank? || member =~ /\/assets\/generic_avatar\_\w*.png/)
      total += 1
    end
    (count/total * 100).to_i
  end
  
  # fields not in profile wizard completion
  def profile_except_wizard_completion_count
    [self.bio, self.custom_url, self.school_id, self.majors, self.gpa, self.gender, self.extracurriculars].reject { |member| member.blank? }.count
  end
  
  def profile_complete?
    self.profile_completion_percentage >= 100
  end
  
  def extracurriculars_list
    self.extracurriculars.collect {|e| e.name}.join(",")
  end
  
  def all_messages(attributes = {})
    recieved = Message.where({
      :received_messageable_id => self.id, 
      :received_messageable_type => self.class.to_s,
      :parent_id => nil, :spam => 0, :abuse => 0
      }.merge(attributes)).order("id desc")
    
    sent = MessageCopy.where({
      :sent_messageable_id => get_sender_id(attributes), 
      :sent_messageable_type => self.class.to_s,
      :parent_id => nil, :spam => 0, :abuse => 0
      }.merge(attributes)).order("id desc")
    
    (recieved + sent).sort { |a, b| b.created_at <=> a.created_at }
  end
  
  def alpha_ordered_notebooks(filter_params = {})
    nbs = notebooks.where(filter_params)
    compact_names = nbs.collect{|n| n.course.try(:compact_name)}.uniq.compact.sort
    ordered_notebooks = []
    compact_names.each do |cn|
      notebook_for_course = []
      nbs.each do |notebook|
        notebook_for_course << notebook if notebook.course.try(:compact_name) == cn
      end
      ordered_notebooks << notebook_for_course.sort_by!{|n| n.name}
    end
    ordered_notebooks << nbs.collect{|n| n if n.course.nil?}.compact.sort_by{|n| n.name}
    ordered_notebooks.flatten.compact
  end
  
  def get_sender_id(attributes)
    sender_id = attributes[:sender_id] || self.id
    attributes.delete :sender_id if attributes[:sender_id]
    sender_id
  end


  private
  # The following two methods are implemnented as a workaround for the issue 
  # described in Paperclip Issue 603 on Github. 
  # Namely: nobody wants to make Paperclip responsible for storing URL friendly
  # filenames because it seems like the wrong place to implement that functioanlity. 
  # Lazy Thoughtbotters. 
  def paperclip_hack_filename
    extension = File.extname(avatar_file_name).gsub(/^\.+/, '')
    filename = avatar_file_name.gsub(/\.#{extension}$/, '')
    self.avatar.instance_write(:file_name, "#{hack_filename(filename)}.#{hack_filename(extension)}")
  end
  def hack_filename(s)
    s.downcase!
    s.gsub!(/'/, '')
    s.gsub!(/[^A-Za-z0-9]+/, ' ')
    s.strip!
    s.gsub!(/\ +/, '-')
    return s
  end

end

class User::NotAuthorized < StandardError; end
