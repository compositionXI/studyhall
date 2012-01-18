class Admin::CourseOfferingImportsController < ApplicationController
  
  layout "admin"
  
  def index
    @course_offering_imports = CourseOfferingImport.all
  end
  
  def new
    @course_offering_import = CourseOfferingImport.new
  end
  
  def create
    @course_offering_import = CourseOfferingImport.new params[:course_offering_import]
    if @course_offering_import.save
      parse_csv_file(@course_offering_import)
      redirect_to admin_course_offering_imports_path
    else
      render action: "new"
    end
  end

  def edit
    @course_offering_import = CourseOfferingImport.find params[:id]
  end

  def update
    @course_offering_import = CourseOfferingImport.find params[:id]
    if @course_offering_import.update_attributes params[:course_offering_import]
      parse_csv_file(@course_offering_import)
      redirect_to admin_course_offering_imports_path
    else
      render action: "edit"
    end
  end

  def destroy
    @course_offering_import = CourseOfferingImport.find params[:id]
    @course_offering_import.delete
    redirect_to admin_course_offering_imports_path
  end
  
  def import
    @course_offering_import = CourseOfferingImport.find params[:id]
    parse_csv_file @course_offering_import
    redirect_to admin_course_offering_imports_path
  end
  
  private
    def parse_csv_file(coi) #FIXME Chill, bro, it's only 40 lines!
      require "csv"
      path_to_file = "public/system/course_offering_imports/#{coi.id}/original/#{coi.course_offering_import_file_name}"
      lines = CSV.read path_to_file
      lines = lines[1...lines.length] #skip headers
      
      lines.each do |line|
        school_name = line[0].strip
        course_number = line[1].strip
        course_title = line[2].strip
        department = line[3].strip
        instructor_list = line[5]
        term = line[6].strip
        
        school = School.find_by_name(school_name)
        if school.nil?
          school = School.create(name: school_name)
        end
        
        course = Course.where("school_id = ? AND title = ? AND number = ? AND department = ?",
                                school.id, course_title, course_number, department).first
        if course.nil?
          course = Course.create(number: course_number,
                                  title: course_title,
                                  school_id: school.id, 
                                  department: department)
        end
        
        instructor_list.split(";").each do |inst_names|
          inst_names = inst_names.strip.split(/\b/)
          first_name = inst_names[0]
          last_name = inst_names[1...inst_names.length].join.strip
          instructor = Instructor.where("first_name = ? AND last_name = ?", first_name, last_name).first
          if instructor.nil?
            instructor = Instructor.create(last_name: last_name, first_name: first_name)
          end
          Offering.create(course_id: course.id, school_id: school.id, instructor_id: instructor.id, term: term)
        end
      end
    end
end
