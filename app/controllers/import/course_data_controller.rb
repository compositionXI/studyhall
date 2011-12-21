class Import::CourseDataController < ApplicationController
  
  layout "admin"
  
  def index
    @course_offering_imports = CourseOfferingImport.order("created_at DESC").all
  end
  
  def new
    @course_offering_import = CourseOfferingImport.new
  end
  
  def create
    @course_offering_import = CourseOfferingImport.new params[:course_offering_import]
    if @course_offering_import.save
      parse_csv_file(@course_offering_import)
      redirect_to import_course_data_path
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
      redirect_to import_course_data_path
    else
      render action: "edit"
    end
  end

  def destroy
    @course_offering_import = CourseOfferingImport.find params[:id]
    @course_offering_import.delete
    redirect_to import_course_data_path
  end
  
  def import
    @course_offering_import = CourseOfferingImport.find params[:id]
    parse_csv_file @course_offering_import
    redirect_to import_course_data_path
  end
  
  # TODO: Move this into a library and refactor. Belongs on the Model, and the models needs an "imported?" flag.
  # TODO: Move the parsing of CSVs and cretion of records form them into a delayed job. 
  # TODO: Have a better state machine for showing the status of file imports. 
  private
    def parse_csv_file(coi) #FIXME Chill, bro, it's only 40 lines!
      require "csv" # FIXME: Seriously, Brent?
      path_to_file = "public/system/course_offering_imports/#{coi.id}/original/#{coi.course_offering_import_file_name}" # FIXME: Again. Really?
      
      lines = CSV.read path_to_file # FIXME: Use the right iterator here and pass a block. 
      lines = lines[1...lines.length] #skip headers # FIXME: Do this by initializing CSV correctly instead of this bullshit hardcoded mistake.
      
      lines.each do |line|
        school_name, course_number, course_title, department, instructor_list, term = line
        [ school_name, course_number, course_title, department, instructor_list, term ].each { |s| s ? s.strip! : nil} 

        school = School.find_or_create_by_name(school_name)
        course = Course.find_or_create_by_school_id_and_title_and_number_and_department(
          school.id, 
          course_title, 
          course_number, 
          department
        )
        
        parse_instructor_list(instructor_list, course.id, school.id, term)
      end
      coi.save!
    end
  
    def parse_instructor_list(instructor_list, course_id, school_id, term)
      return unless instructor_list
      instructor_list.split(";").each do |inst_names|
        inst_names = inst_names.strip.split(/\b/)
        first_name = inst_names[0]
        last_name = inst_names[1...inst_names.length].join.strip
        instructor = Instructor.where("first_name = ? AND last_name = ?", first_name, last_name).first
        if instructor.nil?
          instructor = Instructor.create(last_name: last_name, first_name: first_name)
        end
        Offering.create(course_id: course_id, school_id: school_id, instructor_id: instructor.id, term: term)
      end
   end

end

