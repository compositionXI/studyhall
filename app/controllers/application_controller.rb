class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user_session, :current_user
  
  before_filter :current_user, :fetch_static_pages

  private
  
  def current_user_session
    logger.debug "ApplicationController::current_user_session"
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    logger.debug "ApplicationController::current_user"
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end
  
  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      redirect_to home_index_path
      return false
    end
  end
  
  def require_admin
    unless current_user && current_user.admin?
      flash[:notice] = "You do not have permission to do that."
      redirect_to login_path
    end
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def fetch_static_pages
    @static_pages = StaticPage.all
  end
  
  def set_action_bar
    @action_bar = File.exists?("app/views/shared/_#{params[:controller]}_action_bar.html.erb") ? "shared/#{params[:controller]}_action_bar" : nil
  end
end