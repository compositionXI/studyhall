class Course < ActiveRecord::Base
  
  has_many :offerings
  belongs_to :school
  
  validates_presence_of :title, :number, :school_id, :department
  validates_uniqueness_of :title, :scope => [:school_id, :number]

  searchable :auto_remove => true do
    text :title
    text :department
    text :derived_name
    text :school_name
    text :offering_instructors
    string :title
    string :department
    integer :school_id
  end

  def derived_name
    "#{department} #{number} - #{title}"
  end
  
  def compact_name
    "#{department} #{number}"
  end

  def school_name
    school.name
  end
  
  def offering_instructors
    offerings.map {|o| o.instructor.full_name}.join(" ")
  end
  
  def title_has_long_word?(n=14)
    title.split(" ").each do |word|
      return true if word.size.to_i > n
    end
    return false
  end

end
