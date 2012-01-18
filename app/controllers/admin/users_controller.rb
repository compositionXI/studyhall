class Admin::UsersController < UsersController
  
  layout "admin"
    
  before_filter :require_admin
  before_filter :fetch_user, :only => [:show, :edit, :update, :destroy]
    
  # FIXME: Admin users can't create other users because of an issue with a duplicate Persistence Token. Read the API docs and figure out how to fix this. 
  def create
    @user = User.new(params[:user])
    school = school_from_email(params[:user][:email])
    @user.school_id = school.id if school
    @user.role = "Student" 
    raise @user.inspect
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
  
  def school_from_email(email)
    domain = email.split("@")[1]
    School.find_by_domain_name(domain)
  end
end