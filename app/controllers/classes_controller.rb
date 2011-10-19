class ClassesController < ApplicationController

  before_filter :set_action_bar
  
  def index
    @classes = @current_user.offerings
  end
  
  def show
    @class = @current_user.offerings.find params[:id]
    @course = @class.course
    @classmates = @class.classmates(current_user)
    @posts = @class.posts.recent.top_level
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
  
  def offerings_for_school
    @school = School.find(params[:school_id], :include => :offerings)
    @offerings = @school.offerings(:include => [:course, :instructor])
    
    if request.xhr?
      render :json => { :offerings => @offerings.collect {|o| o.course_listing}, :offering_ids => @school.offering_ids }
    end
  end
  
  def classmates
    @class = @current_user.offerings.find(params[:class_id])
    @users = @class.classmates(current_user)
    @title = "Classmates"
    render "shared/users_list.js.erb"
  end
end
