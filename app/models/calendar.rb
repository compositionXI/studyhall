class Calendar < ActiveRecord::Base

  include Ownable

  belongs_to :user
  belongs_to :study_session
  attr_accessible :user_id, :time_start, :time_end, :date_start, :date_end, :study_session_id, :schedule_id, :userjson

  def userjson
    json_cal  = "["
    current_user.calendars.each do |cal|
      json_cal << "{ title: #{cal.date_start},"
      json_cal << "start: #{cal.date_start},"
      json_cal << "end: #{cal.date_start} }"
    end
    json_cal << "]"
    json_cal
  end

end
