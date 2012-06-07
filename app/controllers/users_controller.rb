class UsersController < ApplicationController
  
  before_filter :require_no_user_or_admin, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :account]
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy, :profile_wizard, :account]
  before_filter :set_action_bar, :only => [:show, :edit]
  before_filter :check_first_last_name, :only => :profile_wizard
  skip_before_filter :require_first_last_name, :only => [:profile_wizard, :update, :show]

  def make_admin
    @modal_link_id = params[:modal_link_id]
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @group.admins << User.find(@user)
    respond_to do |format|
      format.js
    end
  end
  
  def index
    if current_user
      redirect_back_or_default current_user
    else
      redirect_to login_path
    end
  end
  
  def show
    redirect_to login_path, flash: {notice: "You must log in to view that profile"} unless @user.googleable? || current_user
    if !current_user
      @googleview = true
    end
    if params[:tour]
      flash[:action_bar_message] = 'Welcome to StudyHall!'
    else
      if @user.majors.blank?
        flash[:action_bar_message] = "#{@user.name}"
      else
        flash[:action_bar_message] = "#{@user.name} - #{@user.majors.map(&:name).join(", ")}"
      end
    end
  end
  
  def new
    @user = User.new(params[:user])
  end
  
  def create #@user.deliver_activation_instructions!
    @user = User.new params[:user]
    if @user.save_without_session_maintenance
      debugger
      if @user.school and @user.school.active # I need to make a school or something active so I can test it.. do this tomorrow
        flash[:notice] = "Instructions to activate your account have been emailed to you. Please check your email." 
      elsif @user.school and not @user.school.active
        flash[:notice] = "Access to your school has not been granted yet. Stay Tuned for when we launch at your school." 
      elsif !@user.school
        flash[:error] = "this could help"
      else
        flash[:error] = "You must sign up for Studyhall using your school email address (ie. georgetown.edu)." 
      end 
    else
      @user_with_same_email = User.find_by_email(@user.email) if @user.errors[:email].include?('has already been taken')
      if @user_with_same_email
        if @user_with_same_email.active
          flash[:error] = "There is already an account with that email address. You can <a href='/password_resets/new'>reset your password</a> if you forget it.".html_safe
        else
          if @user_with_same_email.school and @user_with_same_email.school.try(:active)
            flash[:error] = "There is already an account with that email address. If you did not receive the activation message, we can <a href='/activations/new?email=#{@user_with_same_email.email}'>send it to you again.</a>".html_safe
          elsif @user_with_same_email.school and not @user_with_same_email.school.try(:active)
            flash[:error] = "There is already an account with that email address. But access to this school has not been granted yet. Stay Tuned for when we launch at this school." 
          else
            flash[:error] = "You must sign up for Studyhall using your school email address (ie. harvard.edu)." 
          end
        end
      end
    end
    
    
    respond_to do |format| #this is what format the client wants the page in
      format.html{ @user.new_record? ? render(:action => 'new') : render(:action => 'wait') } #redirect_to(login_url) }
       #if user.new_record? = true, redirect to the login_url, else render a new view - why action: :new?
       # new_record? return true if it's a new record, false if it isn't
      format.js
    end
  end
  
  def wait
    
  end
  
  def edit
    unless @user.editable_by? @current_user
      redirect_back_or_default @user
    end
    
    flash[:action_bar_message] = "Click the parts of the profile you want to edit."
  end
  
  def update
    check_tour_mode
    @user.avatar = nil if params[:delete_avatar] == "1"
    params[:user][:extracurricular_ids] = @user.split_attribute_list(params[:extracurriculars_list], Extracurricular, :extracurricular_ids) if params[:extracurriculars_list].present?
    if @user.update_attributes(params[:user])
      if @user.majors.blank?
        @action_bar_message = "#{@user.name}"
      else
        @action_bar_message = "#{@user.name} - #{@user.majors.map(&:name).join(",")}"
      end
      flash[:notice] = "Account updated!"
      @success = true
      respond_to do |format|
        format.html { 
          referrer_path = URI(request.referrer).path
          if referrer_path == user_account_path(@user)
            redirect_to user_account_path(@user)
          else
            redirect_to @user 
          end
        }
        format.js {@user.reload}
      end
    else
      if params[:redirect_back] == "profile_wizard"
        render :action => :profile_wizard, :layout => 'plain'
      else
        render :action => :account
      end
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Account deleted!"
    redirect_to root_path
  end
  
  def account
    logger.debug "UsersController#account"
  end
  
  def profile_wizard
    render :layout => 'plain'
  end
  
  def completion_percentage
  end
  
  def extracurriculars
    if request.xhr?
      json = []
      Extracurricular.search(params[:term]).each do |e|
        json << {id: e.name, label: e.name, value: e.name}
      end
      render :json => json
    else
      redirect_to root_url
    end
  end
  
  def drop_class
    offering = Offering.find params[:offering_id]
    enrollment = @current_user.enrollments.find_by_offering_id offering.id
    offering.posts.create(:user_id => current_user.id, :text => "#{@current_user.name} dropped this class.")
    enrollment.delete
    #@course_id = offering.id
    @calendar = Calendar.where(:course_id => offering.id.to_s)
    @calendar.each do |cal|
      cal.update_attributes(:days => 'deleted')
    end
    redirect_to :controller => "home", :action => "index"
  end

  def block
    store_location
    blocked_user = User.find params[:blocked_user_id]
    current_user.block!(blocked_user)
    redirect_to request.referer
  end

  protected
  def redirect_to_user
    redirect_to @user
  end
  
  private
  def fetch_user
    if params[:id] =~ /^\d+$/
      @user =  User.find(params[:id])
      redirect_to profile_path(@user.custom_url, :mode => params[:mode]) if @user && action_name == "show"
    elsif params[:user_id]
      @user =  User.find(params[:user_id])
    else # (was: elsif params[:id] =~ /^[a-z0-9]+$/)
      @user = User.find_by_custom_url(params[:id])
    end
  end
  
  def require_no_user_or_admin
    require_admin if current_user
  end
  
  def check_first_last_name
    unless (current_user.first_name.blank? && current_user.last_name.blank?)
      redirect_to user_path(current_user)
    end
  end

  def check_tour_mode
    if request.referrer.include?('tour')
      @tour = true
      @rel_form = params[:rel_form]
      forms = ['name_form', 'affiliations_form', 'bio_form', 'photo_form', 'gpa_form', 'invitations_form']
      index = forms.index(@rel_form)
      @next_form = forms[index + 1]
    end
  end

end
