class Room < ActiveRecord::Base
  set_table_name :rooms
  belongs_to :study_session
end
