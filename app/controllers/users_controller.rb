class UsersController < ApplicationController
  
  layout "application"
  
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
    @user.role = "Student" unless @current_user.has_role? "Admin"
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to @user
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
    if @user.update_attributes params[:user]
      flash[:notice] = "Account updated!"
      redirect_to @user
    else
      render :action => :edit
    end
  end
  
  def destroy
  end
  
  private
  def fetch_user
    @user = User.find params[:id]
  end
  
  def require_no_user_or_admin
    require_admin if current_user
  end
  
end