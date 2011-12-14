class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
  
  validates_presence_of :title, :number, :school_id, :department
  validates_uniqueness_of :title, :scope => [:school_id, :number]

  searchable :auto_index => true, :auto_remove => true do
    text :title, :department, :derived_name
    integer :school_id
  end

  def derived_name
    "#{department} #{number} - #{title}"
  end

end
