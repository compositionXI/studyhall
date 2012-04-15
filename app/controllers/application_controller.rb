class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user_session, :current_user
  
  before_filter :current_user, :fetch_static_pages, :require_first_last_name, :initial_broadcasts, :clear_broadcasts
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  rescue_from User::NotAuthorized, with: :deny_access

  private
  
  def record_not_found
    flash[:action_bar_message] = "Page Not Found!"
    @action_bar = "/shared/error_action_bar"
    render "public/404.html", :status => 404, :layout => false
  end
  
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
    unless logged_in?
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
  
  def require_first_last_name
    if current_user && (current_user.first_name.blank? || current_user.last_name.blank?)
      #redirect_to profile_wizard_user_path(current_user)
      redirect_to custom_user_path(current_user.custom_url, tour: true)
    end
  end
  
  def require_admin
    unless is_admin?
      flash[:notice] = "You do not have permission to do that."
      redirect_to login_path
    end
  end
  
  def is_admin?
    current_user && current_user.admin?
  end
  
  def logged_in?
    current_user
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
    @action_bar = File.exists?("app/views/#{params[:controller]}/_action_bar.html.erb") ? "#{params[:controller]}/action_bar" : nil
    flash[:action_bar_message] ||= nil
  end
  
  def deny_access
    path = request.referrer || root_path
    redirect_to path, error: "You don't have permissoin to view that page"
  end

  def push_broadcast(intent, options = {})
    if current_user
      case intent
      when :studyhall_created
        message = "#{current_user.name} created the Studyhall \"#{options[:name]}\"" if options.key?(:name)
      when :message_sent
        message = "#{current_user.name} sent you a message."
      when :class_post
        message = "#{current_user.name} posted to the class \"#{options[:name]}\"."
      end
      uri = URI.parse("http://localhost:9292/faye")
      if options[:users]
        options[:users].each do |u|
          data = {:user_id => u.id, :message => message, :intent => intent.to_s, :current => true, :args => options}
          serialized_data = data.to_json
          notification = {:channel => "/broadcasts/user/#{u.id}", :data => serialized_data}
          Net::HTTP.post_form(uri, :message => notification.to_json) if Broadcast.create(data)
        end
      else
        Following.where("followed_user_id = ?", current_user.id).each do |f|
          data = {:user_id => f.user_id, :message => message, :intent => intent.to_s, :current => true, :args => options}
          serialized_data = data.to_json
          notification = {:channel => "/broadcasts/user/#{f.user_id}", :data => serialized_data}
          logger.info("BIZZ:#{data}")
          Net::HTTP.post_form(uri, :message => notification.to_json) if Broadcast.create(data)
        end
      end 
    end
	end

  def initial_broadcasts
    @broadcasts = Broadcast.where("user_id = ?", current_user.id).limit(4) if current_user
    @current_broadcasts = []
    if @broadcasts
      @broadcasts.each do |b|
        @current_broadcasts << b if b.current
      end
    end
  end

  def clear_broadcasts
    #if params[:clear_broadcasts]
    #  current_user.broadcasts.each do |b|
    #    b.update_attribute(:current, false)
    #  end
    #end
  end

end
