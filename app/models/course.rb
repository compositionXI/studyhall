class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
  
  validates_presence_of :title, :number, :school_id, :department
  validates_uniqueness_of :title, :scope => [:school_id, :number]

  searchable do
    text :title, :department, :derived_name
    integer :school_id
  end

  def derived_name
    "#{department} #{number} - #{title}"
  end
  
  def compact_name
    "#{department} #{number}"
  end
end
