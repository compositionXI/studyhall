class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { Note.where(:notebook_id => nil) }
  
end
