module Ownable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    scope :viewable_by, (lambda do |user|
      if user
        where("shareable = ? OR #{table_name}.user_id = ?", true, user.id)
      else
        where(:shareable => true)
      end
    end)
    scope :shared, where(:shareable => true)
  end

  def table_name
    self.class.table_name
  end

  def owner
    self.user
  end

  def can_edit?(_user)
    self.user == _user
  end

  def share!
    self.update_attribute(:shareable, true)
  end
end
