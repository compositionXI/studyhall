class UsersController < ApplicationController
  
  before_filter :require_no_user_or_admin, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.roles = Role.find_by_name("Student") if params[:user][:role_ids].nil?
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to_user
    else
      render :action => :new
    end
  end
  
  def edit
    unless @user.editable_by? @current_user
      redirect_back_or_default @user
    end
  end
  
  def update
    params[:user][:role_ids] ||= []
    @user.avatar = nil if params[:delete_avatar] == "1"
    if @user.update_attributes params[:user]
      flash[:notice] = "Account updated!"
      redirect_to_user
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Account deleted!"
    redirect_to admin_users_path
  end

  protected
  def redirect_to_user
    redirect_to @user
  end
  
  private
  def fetch_user
    @user = User.find params[:id]
  end
  
  def require_no_user_or_admin
    require_admin if current_user
  end
  
  
end