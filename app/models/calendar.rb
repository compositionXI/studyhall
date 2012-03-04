class Calendar < ActiveRecord::Base

  include Ownable

  belongs_to :user
  belongs_to :study_session
  attr_accessible :user_id, :time_start, :time_end, :date_start, :date_end, :study_session_id, :schedule_id

end
