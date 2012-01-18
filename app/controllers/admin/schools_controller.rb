class Admin::SchoolsController < ApplicationController
  
  layout "admin"
  
  def index
    @schools = School.all
  end
    
  def new
    @school = School.new
  end
  
  def create
    @school = School.new params[:school]
    if @school.save
      redirect_to admin_schools_path
    else
      render action: "new"
    end
  end
  
  def edit
    @school = School.find params[:id]
  end
  
  def update
    @school = School.find params[:id]
    if @school.update_attributes params[:school]
      redirect_to admin_schools_path
    else
      render action: "edit"
    end
  end
  
  def destroy
    @school = School.find params[:id]
    @school.delete
    redirect_to admin_schools_path
  end
end
