class Note < ActiveRecord::Base
  
  include Ownable
  BEGINNING_OF_TIME = Time.at(0).strftime('%Y-%m-%d')
  TODAY = Time.new.strftime('%Y-%m-%d')

  has_attached_file :doc,
    :default_url => "/assets/generic_avatar_:style.png",
    :storage => :s3, 
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :bucket => "bucket_dev_sh0" # "studyhall#{Rails.env}"

  attr_accessor :upload
  before_post_process :paperclip_hack_filename

  has_and_belongs_to_many :users
  has_and_belongs_to_many :groups

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

  def privacy_option
    if self.private
      :private
    elsif self.share_all
      :all
    elsif self.share_school
      :school
    else
      :select
    end
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

  private
  # The following two methods are implemnented as a workaround for the issue 
  # described in Paperclip Issue 603 on Github. 
  # Namely: nobody wants to make Paperclip responsible for storing URL friendly
  # filenames because it seems like the wrong place to implement that functioanlity. 
  # Lazy Thoughtbotters. 
  def paperclip_hack_filename
    extension = File.extname(doc_file_name).gsub(/^\.+/, '')
    filename = doc_file_name.gsub(/\.#{extension}$/, '')
    self.doc.instance_write(:file_name, "#{hack_filename(filename)}.#{hack_filename(extension)}")
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
