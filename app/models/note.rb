class Note < ActiveRecord::Base
  
  include Ownable

  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { Note.where(:notebook_id => nil) }
  
end
