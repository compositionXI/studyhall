# -*- coding: utf-8 -*-
# Stuff we can expect from Facebook: 
# <OmniAuth::AuthHash::InfoHash 
#   email="jackson_peter@me.com" 
#   first_name="Pete" 
#   image="http://graph.facebook.com/1312502783/picture?type=square"
#   last_name="Jackson" 
#   name="Pete Jackson" 
#   nickname="jackson.peter" 
#   urls=#<Hashie::Mash Facebook="http://www.facebook.com/jackson.peter">> 
#   provider="facebook" 
#   uid="1312502783">
#
class AuthenticationsController < ApplicationController
  before_filter :require_user, only: [:index, :destroy]
  
  def index
    @authentications = current_user.authentications
  end


  # TODO: DRY this method up. It's long.
  def create

    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication
      @user_session = UserSession.create(authentication.user, true)
      redirect_to root_url, notice: "Login successful!"
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to current_user, notice: "You have successfully linked your #{omniauth['provider'].titleize} account."
    else # There is no authentication object and nobody is logged in. Look email up and link the accounts. 
      u = User.find_by_email(omniauth['info']['email']) if omniauth['info']['email']
      if u  # Link the account to facebook and log them in. 
        u.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        u.activate! unless u.active?
        @user_session = UserSession.create(u, true)
        redirect_to u, notice: "You have successfully linked your #{omniauth['provider'].titleize} account."
      else  # Create the user and forward them to the new user page.
        @user = User.new(:first_name => omniauth['info']['first_name'], 
                     :last_name  => omniauth['info']['last_name'], 
                     :custom_url => omniauth['info']['nickname'] ? omniauth['info']['nickname'] : "#{omniauth['info']['first_name']}#{omniauth['info']['last_name']}",
                     :password   => APP_CONFIG["facebook"]["app_secret"],
                     :email      => omniauth['info']['email']
                     )
         if @user.save
           @user.activate!
           @user.deliver_welcome!
           @user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
           UserSession.create(@user, false) # Log user in manually
           redirect_to profile_wizard_user_url(@user.id)
         else
           render 'users/new'
         end
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, notice: 'Authentication has been deleted!'
  end
end
