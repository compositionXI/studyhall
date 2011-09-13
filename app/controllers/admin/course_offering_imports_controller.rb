class Admin::CourseOfferingImportsController < ApplicationController
  def index
    @course_offering_imports = CourseOfferingImport.all
  end

  def show
    @course_offering_import = CourseOfferingImport.find params[:id]
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
  
  private
    def parse_csv_file(coi)
      require "csv"
      path_to_file = "public/system/course_offering_imports/#{coi.id}/original/#{coi.course_offering_import_file_name}"
      lines = CSV.read path_to_file
      
      lines.each do |line|
        course = Course.where("school_id = ? AND title = ? AND number = ?", coi.school_id, line[1], line[2]).first
        if course.nil?
          course = Course.create(number: line[2], title: line[1], school_id: coi.school_id)
        end
        
        instructor = Instructor.where("first_name = ? AND last_name = ?", line[5], line[4]).first
        if instructor.nil?
          instructor = Instructor.create(last_name: line[4], first_name: line[5])
        end
        Offering.create(course_id: course.id, term_id: coi.term_id, school_id: coi.school_id, instructor_id: instructor.id, section: line[0])
      end
    end
end
