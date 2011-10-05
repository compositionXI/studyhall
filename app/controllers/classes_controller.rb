class ClassesController < ApplicationController

  before_filter :set_action_bar
  
  def index
    @classes = @current_user.offerings
  end
  
  def show
    @class = @current_user.offerings.find params[:id]
    @course = @class.course
    
    flash[:action_bar_message] = @course.title
  end
  
  def new
    @enrollment = Enrollment.new
    @offerings = Offering.includes(:course, :school, :instructor)
    @user = @current_user
  end
  
  def create
    @enrollment = Enrollment.new params[:enrollment]
    @enrollment.user_id = @current_user.id
    
    if @enrollment.save
      redirect_to classes_path
    else
      render action: "new"
    end
  end
  
  def update
  end
  
  def destroy
    @enrollment = @current_user.enrollments.find_by_offering_id params[:id]
    @enrollment.destroy
    redirect_to classes_path
  end
end
