class Note < ActiveRecord::Base
  
  include Ownable

  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { where(:notebook_id => nil) }
  scope :in_range, lambda {|start_date, end_date| where("created_at between ? and ?", start_date, (Time.parse(end_date) + 1.day).strftime('%Y/%m/%d').gsub("/", "-")) unless start_date.blank? || end_date.blank? }
  
  before_save :check_note_name
  before_save :take_parent_permission
  
  attr_accessor :notebook_changed
  
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
  
  protected 
    
    def check_note_name
      if self.name.blank?
        self.name = "Quick Save - #{self.owner.notes.count}"
      end
    end
    
    def take_parent_permission
      if self.notebook_id_changed? && self.notebook
        self.shareable = self.notebook.shareable
        self.notebook_changed = true
      end
    end
end
