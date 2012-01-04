class Notebook < ActiveRecord::Base
  
  include Ownable
  BEGINNING_OF_TIME = Time.at(0).strftime('%Y-%m-%d')
  TODAY = Time.new.strftime('%Y-%m-%d')

  belongs_to :course
  has_many :notes, :dependent => :destroy
  has_many :post, :dependent => :destroy
  
  scope :for_course, lambda {|course| where("course_id = ?", course.id) }
  scope :in_range, lambda {|start_date, end_date|
    start_date = start_date.blank? ? BEGINNING_OF_TIME : start_date
    end_date = end_date.blank? ? TODAY : end_date
    where("created_at >= ? and created_at <= ?", start_date, (Time.parse(end_date) + 1.day).strftime('%Y-%m-%d'))
  }

  def course_name
    course.title if course
  end
  
  def self.alpha_ordered(nbs)
    compact_names = nbs.collect{|n| n.course.try(:compact_name)}.uniq.compact.sort
    ordered_notebooks = []
    compact_names.each do |cn|
      notebook_for_course = []
      nbs.each do |notebook|
        notebook_for_course << notebook if notebook.course.try(:compact_name) == cn
      end
      ordered_notebooks << notebook_for_course.sort_by!{|n| n.name}
    end
    ordered_notebooks << nbs.collect{|n| n if n.course.nil?}.compact.sort_by{|n| n.name}
    ordered_notebooks.flatten.compact
  end

end
