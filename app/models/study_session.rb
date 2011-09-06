class StudySession < ActiveRecord::Base
   has_one :room
   has_one :whiteboard
end
