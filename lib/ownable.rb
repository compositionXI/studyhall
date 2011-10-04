module Ownable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    scope :viewable_by, lambda{|user| where("shareable = ? OR user_id = ?", true, user.id) }
    scope :shared, where(:shareable => true)
  end

  def owner
    self.user
  end

  def can_edit?(_user)
    self.user == _user
  end
end
