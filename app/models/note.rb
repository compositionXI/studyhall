class Note < ActiveRecord::Base
  
  include Ownable

  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { Note.where(:notebook_id => nil) }

  searchable :auto_index => true, :auto_remove => true do
    text :name, :content
    boolean :shareable
  end

  def course_name
    notebook.course.title if notebook && notebook.course
  end
  
end
