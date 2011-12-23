class Note < ActiveRecord::Base
  
  include Ownable

  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { where(:notebook_id => nil) }
  scope :in_range, lambda {|start_date, end_date| where("created_at between ? and ?", start_date, end_date) unless start_date.blank? || end_date.blank? }

  searchable :auto_index => true, :auto_remove => true do
    text :name
    text :content
    text :owner_name
    text :notebook_name
    text :course_name
    boolean :shareable
  end

  def course_name
    notebook.course.title if notebook && notebook.course
  end
  
  def notebook_name
    notebook.name if notebook
  end
  
  def owner_name
    user.name
  end
  
end
