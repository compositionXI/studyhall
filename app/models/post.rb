class Post < ActiveRecord::Base
  
  belongs_to :offering
  belongs_to :user
  belongs_to :notebook
  belongs_to :study_session
  
  scope :recent, :limit => 20, :order => 'updated_at DESC'
  
end
