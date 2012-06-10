class ClassesController < ApplicationController

  before_filter :set_action_bar
  def index
    @classes = @current_user.offerings
  end
  
  def show
    @group_post = false
    if request.xhr?
      dept_name = params[:dept_name]
      number = params[:number]
      if(number == 'none')
        course_nos = Course.select(:number).where(:school_id => @current_user.school.id, :department => dept_name).uniq.collect{|c| c.number }
        course_nos = course_nos.map{|cn| cn }.sort!
        course_no_string = ''
        course_nos.each do |cn|
          course_no_string << '<option value="' + cn.to_s + '">' + cn.to_s + '</option>'
        end
        render :text => course_no_string
      else
        course_name = Course.select(:title).where(:school_id => @current_user.school.id, :department => dept_name, :number => number).collect{|c| c.title }   
        render :text => dept_name + ' ' + number + ': ' + course_name.first
      end
    else
      @class = Offering.find(params[:id])
      @course = @class.course
      @textbook = Textbook.where(:course_id => @course.id).first
      @classmates = @class.classmates(current_user)
      @posts = @class.posts.where("post_type <= ?", 'class').recent.top_level
      @shared_study_sessions = @class.study_sessions.viewable_by nil
      @shared_notes = @class.notes.viewable_by nil
      flash[:action_bar_message] = @course.title
    end
  end
  
  def new
    @enrollment = Enrollment.new
    #@offerings = Offering.where(school_id: current_user.school.id).includes(:course, :school, :instructor)
    #@offerings = current_user.school.offerings.includes(:course, :instructor)
    @user = @current_user
    respond_to do |format|
      if request.xhr?
        @modal_link_id = params[:link_id]
      end
      format.js
    end
  end
  
  def create
    #@enrollment = Enrollment.new params[:enrollment]
    department = params[:class][:department]
    number = params[:class][:number].first
    @course = Course.where(:department => department, :number => number.to_s, :school_id => current_user.school.id).first
    @offering = Offering.where(:course_id => @course.id).first
    if(@offering.nil?)
      @offering = Offering.new
      @offering.course = @course
      @offering.school = current_user.school
      @offering.save
    end
    @enrollment = Enrollment.new
    @enrollment.offering = @offering
    @enrollment.user = current_user
    
    #add the calendar event
    days = ''
    days << '1' if(params[:mon] == 'on')
    days << '2' if(params[:tue] == 'on')
    days << '3' if(params[:wed] == 'on')
    days << '4' if(params[:thu] == 'on')
    days << '5' if(params[:fri] == 'on')
    
    @calendar = Calendar.new
    @calendar.update_attributes({ :days => days, :course_id => @offering.id, :time_start => params[:class_start][:time], :time_end => params[:class_end][:time], :user_id => current_user.id, :course_name => @course.title })
    
    
    if @enrollment.save
      @calendar.save
      if request.xhr?
        render partial: 'users/course_list', collection: current_user.offerings, as: :offering, :locals => {:wrapper_class => "wrapper_large"}
      else
        redirect_to classes_path
      end
      enroll = Enrollment.where(:offering_id => @offering.id)
      allstuds = [current_user.id.to_s]
      enroll.each do |enr|
        allstuds += [enr.user_id.to_s]
      end
      Recommendation.populate_user(allstuds)
      allstuds.shift
      Recommendation.connect_new(current_user.id, allstuds, 1)
      
    else
      @user = current_user
      render action: "new"
    end
  end
  
  def update
  end
  
  def destroy
    @enrollment = @current_user.enrollments.find_by_offering_id params[:id]
    @enrollment.destroy
    redirect_to :controller => "home", :action => "index"
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
