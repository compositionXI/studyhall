class CourseOfferingImport < ActiveRecord::Base
  belongs_to :school 
  has_attached_file :course_offering_import

  include CourseOfferingImporter

  include ActiveRecord::Transitions
  state_machine do
    state :pending
    state :imported
    event :import do
      transitions :to => :imported, :from => :pending
    end
  end
  
  def import!
    parse_csv_file(self.course_offering_import.path)
    self.import
  end
end
