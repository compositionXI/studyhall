class Admin::UsersController < UsersController
  
  layout "admin"
    
  before_filter :require_admin
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy]
    
  # FIXME: Admin users can't create other users because of an issue with a duplicate Persistence Token. Read the API docs and figure out how to fix this. 
  def create
    @user = User.new params[:user]
    @user.role = "Student" 
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to_user
    else
      render :action => :new
    end
  end
  
  protected
  def redirect_to_user
    redirect_to admin_user_path @user
  end
  
  private
  def fetch_user
    @user = User.find params[:id]
  end
  
  
end