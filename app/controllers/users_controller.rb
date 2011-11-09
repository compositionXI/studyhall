class UsersController < ApplicationController
  
  before_filter :require_no_user_or_admin, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :account]
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy, :profile_wizard, :account]
  before_filter :set_action_bar, :only => [:show, :edit]
  
  def index
    @users = User.all
  end
  
  def show
    @notebooks = Notebook.find_by_user_id @user.id
    flash[:action_bar_message] = "#{@user.name} - #{@user.major}"
  end
  
  def new
    @user = User.new(params[:user])
  end
  
  def create
    @user = User.new params[:user]
    school = school_from_email(params[:user][:email])
    @user.school_id = school.id if school
    @user.roles << Role.find_by_name("Student") if params[:user][:role_ids].nil?
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Instructions to activate your account have been emailed to you. \nPlease check your email."  
    end
    respond_to do |format|
      format.html { @user.new_record? ? render(action: :new) : redirect_to(login_url) }
      format.js
    end
  end
  
  def edit
    unless @user.editable_by? @current_user
      redirect_back_or_default @user
    end
    
    flash[:action_bar_message] = "Click the parts of the profile you want to edit."
  end
  
  def update
    @user.avatar = nil if params[:delete_avatar] == "1"
    params[:user][:extracurricular_ids] = @user.split_attribute_list(params[:extracurriculars_list], Extracurricular, :extracurricular_ids) if params[:extracurriculars_list].present?
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      @success = true
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      render :action => :account
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Account deleted!"
    redirect_to admin_users_path
  end
  
  def account
    logger.debug "UsersController#account"
  end
  
  def profile_wizard
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
  
  def buddies
    @user = User.find params[:user_id]
    @users = @user.buddies.sort_by(&:name)
    @title = "Buddies"
    render "shared/users_list.js.erb"
  end
  
  def drop_class
    enrollment = @current_user.enrollments.find_by_offering_id params[:offering_id]
    offering = Offering.find params[:offering_id]
    offering.posts.create(:user_id => current_user.id, :text => "#{@current_user.name} dropped this class.")
    enrollment.delete
    @course_id = params[:offering_id]
    respond_to do |format|
      format.html { redirect_to root_path flash[:action_bar_message] }
      format.js
    end
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
    @user = (params[:id] =~ /^\d+$/) ? User.find(params[:id]) : User.find_by_custom_url(params[:id])
  end
  
  def require_no_user_or_admin
    require_admin if current_user
  end
  
  def school_from_email(email)
    domain = email.split("@")[1]
    found_school = School.find_by_domain_name(domain)
    return found_school if found_school
    if Rails.env.development? || Rails.env.staging?
      School.last
    else
      nil
    end
  end
end
