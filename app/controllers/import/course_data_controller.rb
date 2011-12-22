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
      @course_offering_import.delay.import!#TODO: maybe the delay should depend on the size of file
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
      @course_offering_import.delay.import!
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
    @course_offering_import.import!
    redirect_to import_course_data_path
  end
end

