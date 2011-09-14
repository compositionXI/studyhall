class Admin::InstructorsController < ApplicationController
  
  layout "admin"
  
  def index
    @admin_instructors = Instructor.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @admin_instructor = Instructor.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @admin_instructor = Instructor.find(params[:id])
  end

  def create
    @admin_instructor = Instructor.new(params[:instructor])

    respond_to do |format|
      if @admin_instructor.save
        format.html { redirect_to admin_instructors_path, notice: 'Instructor was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @admin_instructor = Instructor.find(params[:id])

    respond_to do |format|
      if @admin_instructor.update_attributes(params[:instructor])
        format.html { redirect_to admin_instructors_path, notice: 'Instructor was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @admin_instructor = Instructor.find(params[:id])
    @admin_instructor.destroy

    respond_to do |format|
      format.html { redirect_to admin_instructors_url }
    end
  end
end
