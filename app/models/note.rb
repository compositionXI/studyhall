class Note < ActiveRecord::Base
  
  include Ownable
  BEGINNING_OF_TIME = Time.at(0).strftime('%Y-%m-%d')
  TODAY = Time.new.strftime('%Y-%m-%d')

  belongs_to :notebook
  
  validates_presence_of :user_id
  
  scope :unsorted, lambda { where(:notebook_id => nil) }
  scope :in_range, lambda {|start_date, end_date|
    start_date = start_date.blank? ? BEGINNING_OF_TIME : start_date
    end_date = end_date.blank? ? TODAY : end_date
    where("created_at >= ? and created_at <= ?", start_date, (Time.parse(end_date) + 1.day).strftime('%Y-%m-%d'))
  }
  
  before_save :check_note_name
  before_create do |note|
    note.notebook.shareable = note.shareable if note.notebook
  end
  
  attr_accessor :notebook_changed
  before_save do |note|
    note.notebook_changed = note.notebook_id_changed?
    return true
  end
  
  
  searchable :auto_index => true, :auto_remove => true do
    text :name
    text :content
    text :owner_name
    text :notebook_name
    text :course_name
    boolean :shareable
  end

  def course
    notebook.course if notebook
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
  
  def self.filter_for(user, filter)
    notes = filter[:note] ? user.notes.where(["name like ?", "%#{filter[:note][:name]}%"]) : user.notes
    notes.unsorted.in_range(filter[:start_date], filter[:end_date]).all.flatten.uniq
  end

  #we assume that note and its notebook always have the same value of shareable
  def set_notebook_shareable
    return unless self.notebook
    self.notebook.update_attribute(:shareable, self.shareable) unless self.notebook.shareable == self.shareable
  end
  protected 
    
  def check_note_name
    if self.name.blank?
      self.name = "Quick Save - #{self.owner.notes.count}"
    end
  end
end
