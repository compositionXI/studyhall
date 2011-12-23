class Notebook < ActiveRecord::Base
  
  include Ownable

  belongs_to :course
  has_many :notes, :dependent => :destroy
  has_many :post, :dependent => :destroy
  
  scope :for_course, lambda {|course| where("course_id = ?", course.id) }
  scope :in_range, lambda {|start_date, end_date| where("created_at between ? and ?", start_date, end_date) unless start_date.blank? || end_date.blank? }

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
