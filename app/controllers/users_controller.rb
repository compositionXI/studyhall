class UsersController < ApplicationController
  
  before_filter :fetch_user, :only => ["edit", "show", "destroy"]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create params[:user]
    if @user.save
      redirect_to show @user
    else
      render "edit"
    end
  end
  
  def edit
  end
  
  def update
    @user = User.update_attributes params[:user]
  end
  
  def destroy
  end
  
  private
  def fetch_user
    @user = User.find params[:id]
  end
end