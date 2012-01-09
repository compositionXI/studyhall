class ActivationsController < ApplicationController

  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:update]
  
  def new
    @email = params[:email] ? params[:email] : nil
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      unless @user.active
        @user.deliver_activation_instructions!
        flash[:notice] = "Instructions to activate your account have been emailed to you. \nPlease check your email."
        redirect_to root_url
      else
        flash[:error] = "The account with this email is already activated."
        render :action => :new
      end
    else
      flash[:error] = "No user was found with that email address."
      render :action => :new
    end
  end

  def update
    if @user.activate!
      flash[:notice] = "Your account has been activated!"
      UserSession.create(@user, false) # Log user in manually
      @user.deliver_welcome!
      #redirect_to profile_wizard_user_url(@user.id)
      redirect_to custom_user_path(@user.custom_url, tour: true)
    else
      flash[:error] = 'There was a problem activating your account.'
      redirect_to login_path
    end
  end

  private  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "activation process."
      redirect_to root_path
    end
  end
end
