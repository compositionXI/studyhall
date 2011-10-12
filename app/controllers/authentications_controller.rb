# -*- coding: utf-8 -*-
class AuthenticationsController < ApplicationController
  before_filter :require_user, only: [:index, :destroy]
  
  def index
    @authentications = current_user.authentications
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      UserSession.create(authentication.user)
      redirect_to root_url, notice: "Login successful!"
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'],
                                          :uid => omniauth['uid'])
      redirect_to authentications_url, notice: "Authentication successful."
    else
      # TODO: create user from omniauth
      redirect_to new_user_path, notice: 'Create an account first'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, notice: 'Authentication has been deleted!'
  end
end
