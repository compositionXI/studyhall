class UsersController < ApplicationController
  
  before_filter :require_no_user_or_admin, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy, :profile_wizard]
  before_filter :set_action_bar, :only => [:show, :edit]
  
  def index
    @users = User.all
  end
  
  def show
    @notebooks = Notebook.find_by_user_id @user.id
    flash[:action_bar_message] = "#{@user.name} - #{@user.major}"
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.roles << Role.find_by_name("Student") if params[:user][:role_ids].nil?
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Instructions to activate your account have been emailed to you. \nPlease check your email."  
      redirect_to root_url
    else
      render :action => :new
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
    params[:user][:extracurricular_ids] = @user.split_attribute_list(params[:extracurriculars_list], Extracurricular, :extracurricular_ids)
    
    if @user.update_attributes! params[:user]
      flash[:notice] = "Account updated!"
      
      if request.xhr?
        greek_house = @user.male? ? @user.fraternity : @user.sorority
        render :json => {
          name: @user.name, 
          school: @user.school.name,
          greek_house: greek_house, 
          major: @user.major, 
          gpa: @user.gpa, 
          avatar_url: @user.avatar_url(:large),
          bio: @user.bio
        }
      elsif params[:commit] == "Do This Later"
          redirect_to home_index_path
      else
        redirect_to_user
      end
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Account deleted!"
    redirect_to admin_users_path
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
    render :partial => "shared/buddy_list", :locals => {buddies: @current_user.buddies.sort_by(&:name)}
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
end
