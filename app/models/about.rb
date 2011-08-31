class About < ActiveRecord::Base
  
  scope :on_display, lambda { where('display = ?', true) }
end
