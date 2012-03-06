class Calendar < ActiveRecord::Base
# /\d+/
  include Ownable

  belongs_to :user
  belongs_to :study_session

  attr_accessible :user_id, :time_start, :time_end, :date_start, :date_end, :study_session_id, :schedule_id

  def Calendar.other_user_json(user)
    study_seshs = user.study_sessions
    cal_seshs = []
    study_seshs.each do |sss|
      cal_seshs += Calendar.where(:schedule_id => sss.id)
    end
    json_cal  = "["
      cal_seshs.each do |cal|
        if StudySession.find(cal.schedule_id).name.to_s == ''
          sesh_name = 'Study Session ' + cal.schedule_id.to_s
        else
          sesh_name = StudySession.find(cal.schedule_id).name
        end
        mdy = cal.date_start.to_s.scan(/\d+/)
        mdy[0] = mdy[0].to_i - 1
        hmampm = cal.time_start.to_s.split(' ')
        hm = hmampm[0].scan(/\d+/);
        if hmampm[1] == 'pm'
          hm[0] = hm[0].to_i + 12
        end
        if mdy[0].to_s.empty? || mdy[1].to_s.empty? || mdy[2].to_s.empty?
          date_string = '1900,01,01'
        elsif hm[0].to_s.empty? || hm[1].to_s.empty?
          date_string = mdy[2].to_s+','+mdy[0].to_s+','+mdy[1].to_s
        else
          date_string = mdy[2].to_s+','+mdy[0].to_s+','+mdy[1].to_s+','+hm[0].to_s+','+hm[1].to_s
          full_date = true
        end
        if full_date
          end_hour = hm[0].to_i + 1
          date_string_end = mdy[2].to_s+','+mdy[0].to_s+','+mdy[1].to_s+','+end_hour.to_s+','+hm[1].to_s
          all_day_string = ', allDay: false'
        else
          date_string_end = date_string
          all_day_string = ''
        end
        json_cal << " { title: '#{sesh_name}', "
        json_cal << "start: new Date(#{date_string}), "
        json_cal << "end: new Date(#{date_string_end}), "
        json_cal << "url: 'http://localhost:3000/study_sessions/#{cal.schedule_id}?#{cal.id}'#{all_day_string} },"
      end
    json_cal << " ]"
    json_cal
  end

end
