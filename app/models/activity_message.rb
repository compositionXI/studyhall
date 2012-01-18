class ActivityMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :activist, :class_name => "User", :foreign_key => "activist_id"
end
