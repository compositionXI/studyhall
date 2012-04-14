class ClassesController < ApplicationController

  before_filter :set_action_bar
  
  def index
    @classes = @current_user.offerings
  end
  
  def show
    @class = Offering.find(params[:id])
    @course = @class.course
    @classmates = @class.classmates(current_user)
    @posts = @class.posts.recent.top_level
    @shared_study_sessions = @class.study_sessions.viewable_by nil
    @shared_notes = @class.notes.viewable_by nil
    flash[:action_bar_message] = @course.title
  end
  
  def new
    @enrollment = Enrollment.new
    #@offerings = Offering.where(school_id: current_user.school.id).includes(:course, :school, :instructor)
    @offerings = current_user.school.offerings.includes(:course, :instructor)
    @user = @current_user
    respond_to do |format|
      if request.xhr?
        @modal_link_id = params[:link_id]
      end
      format.js
    end
  end
  
  def create
    @enrollment = Enrollment.new params[:enrollment]
    offerid = params[:enrollment][:offering_id]
    enroll = Enrollment.where(:offering_id => offerid)
    allstuds = [current_user.id.to_s]
    enroll.each do |enr|
      allstuds += [enr.user_id.to_s]
    end
    Recommendation.populate_user(allstuds)
    allstuds.shift
    Recommendation.connect_new(current_user.id, allstuds, 1)
    @enrollment.user_id = @current_user.id
    
    if @enrollment.save
      if request.xhr?
        render partial: 'users/course_list', collection: current_user.offerings, as: :offering, :locals => {:wrapper_class => "wrapper_large"}
      else
        redirect_to classes_path
      end
      
    else
      render action: "new"
    end
  end
  
  def update
  end
  
  def destroy
    @enrollment = @current_user.enrollments.find_by_offering_id params[:id]
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to classes_path }
      format.js
    end
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
