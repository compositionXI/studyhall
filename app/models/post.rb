class Post < ActiveRecord::Base
  
  belongs_to :offering
  belongs_to :user
  belongs_to :notebook
  belongs_to :study_session
  belongs_to :parent, :class_name => "Post"
  has_many :comments, :foreign_key => :parent_id
  
  scope :recent, :limit => 20, :order => 'updated_at DESC'
  scope :top_level, lambda {where :parent_id => nil}
  scope :for_offering, lambda {|offering| where :offering_id => offering.id}
  scope :by_user, lambda { |user| where :user_id => user.id}
  
  def comment?
    self.class.name == "Comment"
  end
end
