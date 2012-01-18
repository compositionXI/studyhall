class Room < ActiveRecord::Base
  self.table_name = 'rooms'
  belongs_to :study_session
end
