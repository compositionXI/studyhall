require 'iconv'
module CourseOfferingImporter 
  def parse_csv_file(path)
    row_count = 0
    CSV.foreach path, :headers => true do |row|
      row_count += 1
      begin
        school_name, course_number, course_title, department, department_code, instructor_list, term = CSV.parse(convert_charset(row.to_s)).flatten.collect{|unit| unit.equal?('N/A') ? nil : unit.try(:strip)}
        school = School.find_or_create_by_name(school_name)
        course = Course.find_or_create_by_school_id_and_title_and_number_and_department(
          school.id,
          course_title,
          course_number,
          department
        )
        parse_instructor_list(instructor_list, course.id, school.id, term)
      rescue Exception => e
        Rails.logger.error "Error in row #{row_count}"
        Rails.logger.error "content is: #{row.to_s}"
        Rails.logger.error "error message is: #{e.message}"
        p "Error in row #{row_count}"
        p "content is: #{row.to_s}"
        p "error message is: #{e.message}"
      end
    end
  end

  def parse_instructor_list(instructor_list, course_id, school_id, term)
    return if instructor_list.blank?
    instructor_list.split(";").each do |inst_names|
      inst_names = inst_names.strip.split(/\b/)
      first_name = inst_names[0]
      last_name = inst_names[1...inst_names.length].join.strip
      instructor = Instructor.find_or_create_by_first_name_and_last_name(first_name, last_name)
      Offering.create(course_id: course_id, school_id: school_id, instructor_id: instructor.id, term: term)
    end
  end

  def convert_charset(s)
    cd = CharDet.detect s
    p cd.confidence
    cd.confidence > 0.6 ? Iconv.conv(cd.encoding, "UTF-8", s) : s
  end
end
