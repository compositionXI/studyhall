class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :notebook

  before_save :extract_name

  protected
  def extract_name
    self.name = content.try(:lines).try(:first).try(:chomp) || 'Untitled'
  end

end
