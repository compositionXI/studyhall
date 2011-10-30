class ActivationsController < ApplicationController

  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:create]

  def create
    if @user.activate!
      flash[:notice] = "Your account has been activated!"
      UserSession.create(@user, false) # Log user in manually
      @user.deliver_welcome!
      redirect_to profile_wizard_user_url(@user.id)
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
