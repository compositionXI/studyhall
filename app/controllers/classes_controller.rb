class ClassesController < ApplicationController
  
  def index
    @classes = @current_user.offerings
  end
  
  def show
    
  end
  
  def new
    @enrollment = Enrollment.new
  end
  
  def create
    @enrollment = Enrollment.new params[:enrollment]
    @enrollment.user_id = @current_user.id
    
    if @enrollment.save
      redirect_to classes_path
    else
      render action: "new"
    end
  end
  
  def update
  end
  
  def destroy
  end
end
