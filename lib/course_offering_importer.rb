require 'iconv'
module CourseOfferingImporter 
  def parse_csv_file(path)
    row_count = 0
    CSV.foreach path, :headers => true do |row|
      row_count += 1
      begin
        school_name, course_number, course_title, department, department_code, instructor_list, term = CSV.parse(convert_charset(row.to_s)).flatten.collect{|unit| unit.eql?('N/A') ? nil : unit.try(:strip)}
        school = School.where(:name => school_name).first || School.create(:name => school_name)
        unless school.persisted?
          log_error "School failed to create: #{school.errors.messages.to_s}", row, row_count
          next
        end
        course = Course.where(:school_id => school.id, :title => course_title, :number => course_number, :department => department).first || Course.create(:school_id => school.id, :title => course_title, :number => course_number, :department => department) 
        if course.persisted?
          parse_instructor_list(instructor_list, course.id, school.id, term)
        else
          log_error "Course failed to create: #{course.errors.messages.to_s}", row, row_count
          next
        end
      rescue Exception => e
        log_error e.message, row, row_count
      end
    end
  end

  def parse_instructor_list(instructor_list, course_id, school_id, term)
    return if instructor_list.blank?
    return if course_id.nil?
    instructor_list.split(";").each do |inst_names|
      inst_names = inst_names.strip.split(/\b/)
      first_name = inst_names[0]
      last_name = inst_names[1...inst_names.length].join.strip
      instructor = Instructor.where(:first_name => first_name, :last_name => last_name).first || Instructor.create(:first_name => first_name, :last_name => last_name)
      Offering.create(course_id: course_id, school_id: school_id, instructor_id: instructor.try(:id), term: term)
    end
  end

  def convert_charset(s)
    cd = CharDet.detect s
    #cd.confidence > 0.6 ? Iconv.conv("UTF-8", cd.encoding, s) : s
    Iconv.conv "UTF-8", cd.encoding, s
  end

  def log_error(message, row, row_count)
    Rails.logger.error "Error in row #{row_count}"
    Rails.logger.error "content is: #{row.to_s}"
    Rails.logger.error "error message is: #{message}"
    p "Error in row #{row_count}"
    p "content is: #{row.to_s}"
    p "error message is: #{message}"
  end
end
