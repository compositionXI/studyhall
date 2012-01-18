class SessionSharingsController < ApplicationController
  
  before_filter :require_user

  def new
    @session_sharing = SessionSharing.new
  end

  def create
  end

end
