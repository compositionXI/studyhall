class Admin::CoursesController < ApplicationController
  
  layout "admin"
  
  def index
    @admin_courses = Course.all

    respond_to do |format|
      format.html 
      format.json { render json: @admin_courses }
    end
  end

  def show
    @admin_course = Course.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @admin_course }
    end
  end

  def new
    @admin_course = Course.new

    respond_to do |format|
      format.html
      format.json { render json: @admin_course }
    end
  end

  def edit
    @admin_course = Course.find(params[:id])
  end

  def create
    @admin_course = Course.new(params[:admin_course])

    respond_to do |format|
      if @admin_course.save
        format.html { redirect_to @admin_course, notice: 'Course was successfully created.' }
        format.json { render json: @admin_course, status: :created, location: @admin_course }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @admin_course = Course.find(params[:id])

    respond_to do |format|
      if @admin_course.update_attributes(params[:admin_course])
        format.html { redirect_to @admin_course, notice: 'Course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_course = Course.find(params[:id])
    @admin_course.destroy

    respond_to do |format|
      format.html { redirect_to admin_courses_url }
      format.json { head :ok }
    end
  end
end
