class Calendar < ActiveRecord::Base

  include Ownable

  belongs_to :user
  belongs_to :study_session

  attr_accessible :user_id, :time_start, :time_end, :date_start, :study_session_id, :schedule_id, :days, :course_id, :course_name

  def Calendar.other_user_json(user)
    study_seshs = user.study_sessions
    study_seshs_ids = []
    study_seshs.each do |ss|
      study_seshs_ids << ss.id
    end
    cal_seshs = Calendar.where(:schedule_id => study_seshs_ids)
    cal_seshs_ss_ids = []
    cal_seshs.each do |cs|
      cal_seshs_ss_ids << cs.schedule_id
    end
#    study_seshs.each do |sss|
#      cal_seshs += Calendar.where(:schedule_id => sss.id)
#    end
    study_seshs_w_cal = StudySession.where(:id => cal_seshs_ss_ids)
    json_cal  = "["
      cal_seshs.each do |cal|
        if study_seshs_w_cal.where(:id => cal.schedule_id).name.to_s == ''
          sesh_name = 'Study Session ' + cal.schedule_id.to_s
        else
          sesh_name = study_seshs_w_cal.where(:id => cal.schedule_id).name
        end
        mdy = cal.date_start.to_s.scan(/\d+/)
        mdy[0] = mdy[0].to_i - 1
        hmampm = cal.time_start.to_s.split(' ')
        hm = hmampm[0].scan(/\d+/);
        if hm[0].to_i == 12
          if hmampm[1] == 'am'
            hm[0].to_i -= 12
          end
        elsif hmampm[1] == 'pm'
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
    
    class_cal = Calendar.where(!:course_id.nil?)
    mon =  ['2012,2,5','2012,2,12','2012,2,19','2012,2,26','2012,3,2','2012,3,9','2012,3,16','2012,3,23','2012,3,30','2012,4,7','2012,4,14','2012,4,21','2012,4,28'] 
    tue = ['2012,2,6','2012,2,13','2012,2,20','2012,2,27','2012,3,3','2012,3,10','2012,3,17','2012,3,24','2012,4,1','2012,4,8','2012,4,15','2012,4,22','2012,4,29'] 
    wed = ['2012,2,7','2012,2,14','2012,2,21','2012,2,28','2012,3,4','2012,3,11','2012,3,18','2012,3,25','2012,4,2','2012,4,9','2012,4,16','2012,4,23','2012,4,30'] 
    thu = ['2012,2,8','2012,2,15','2012,2,22','2012,2,29','2012,3,5','2012,3,12','2012,3,19','2012,3,26','2012,4,3','2012,4,10','2012,4,17','2012,4,24','2012,4,31'] 
    fri = ['2012,2,9','2012,2,16','2012,2,23','2012,2,30','2012,3,6','2012,3,13','2012,3,20','2012,3,27','2012,4,4','2012,4,11','2012,4,18','2012,4,25','2012,5,1'] 
    class_cal.each do |ccl|
    
      hmampm_start = ccl.time_start.to_s.split(' ')
      hm_start = hmampm_start[0].to_s.scan(/\d+/);
      if hm_start[0].to_i == 12
        if hmampm_start[1] == 'am'
          hm_start[0] = '0'
        end
      elsif hmampm_start[1] == 'pm'
        hm_start[0] = hm_start[0].to_i + 12
      end
      
      hmampm_end = ccl.time_end.to_s.split(' ')
      hm_end = hmampm_end[0].to_s.scan(/\d+/);
      if hm_end[0].to_i == 12
        if hmampm_end[1] == 'am'
          hm_end[0] = '0'
        end
      elsif hmampm_end[1] == 'pm'
        hm_end[0] = hm_end[0].to_i + 12
      end
      
      dow = ccl.days.to_s.scan(/\d/)
      course_name = ccl.course_name.to_s.split(' - ')
      dow.each do |day|
        if day == '1'
          mon.each do |m|
            date_string_start = m + ',' + hm_start[0].to_s + ',' + hm_start[1].to_s
            date_string_end = m + ',' + hm_end[0].to_s + ',' + hm_end[1].to_s
            json_cal << " { title: '#{course_name[0]} #{course_name[1]}', "
            json_cal << "start: new Date(#{date_string_start}), "
            json_cal << "end: new Date(#{date_string_end}), "
            json_cal << "url: 'http://localhost:3000/classes/#{ccl.course_id}', allDay: false },"
          end
        end
        if day == '2'
          tue.each do |m|
            date_string_start = m + ',' + hm_start[0].to_s + ',' + hm_start[1].to_s
            date_string_end = m + ',' + hm_end[0].to_s + ',' + hm_end[1].to_s
            json_cal << " { title: '#{course_name[0]} #{course_name[1]}', "
            json_cal << "start: new Date(#{date_string_start}), "
            json_cal << "end: new Date(#{date_string_end}), "
            json_cal << "url: 'http://localhost:3000/classes/#{ccl.course_id}', allDay: false },"
          end
        end
        if day == '3'
          wed.each do |m|
            date_string_start = m + ',' + hm_start[0].to_s + ',' + hm_start[1].to_s
            date_string_end = m + ',' + hm_end[0].to_s + ',' + hm_end[1].to_s
            json_cal << " { title: '#{course_name[0]} #{course_name[1]}', "
            json_cal << "start: new Date(#{date_string_start}), "
            json_cal << "end: new Date(#{date_string_end}), "
            json_cal << "url: 'http://localhost:3000/classes/#{ccl.course_id}', allDay: false },"
          end
        end
        if day == '4'
          thu.each do |m|
            date_string_start = m + ',' + hm_start[0].to_s + ',' + hm_start[1].to_s
            date_string_end = m + ',' + hm_end[0].to_s + ',' + hm_end[1].to_s
            json_cal << " { title: '#{course_name[0]} #{course_name[1]}', "
            json_cal << "start: new Date(#{date_string_start}), "
            json_cal << "end: new Date(#{date_string_end}), "
            json_cal << "url: 'http://localhost:3000/classes/#{ccl.course_id}', allDay: false },"
          end
        end
        if day == '5'
          fri.each do |m|
            date_string_start = m + ',' + hm_start[0].to_s + ',' + hm_start[1].to_s
            date_string_end = m + ',' + hm_end[0].to_s + ',' + hm_end[1].to_s
            json_cal << " { title: '#{course_name[0]} #{course_name[1]}', "
            json_cal << "start: new Date(#{date_string_start}), "
            json_cal << "end: new Date(#{date_string_end}), "
            json_cal << "url: 'http://localhost:3000/classes/#{ccl.course_id}', allDay: false },"
          end
        end
      end
      

    end
    
    json_cal << " ]"
    json_cal
  end

end
