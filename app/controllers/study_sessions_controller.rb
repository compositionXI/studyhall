class StudySessionsController < ApplicationController

  include ActionView::Helpers::TextHelper
  
  before_filter :require_user
  before_filter :set_action_bar, except: [:show]
  before_filter :augment_study_session_params, only: [:create, :update]
  
  def index
    @study_sessions = find_study_sessions
    @study_sessions.each do |study_session|
      study_session.session_files.build
    end
    @index = true
  end
  
  def show
    @study_session = StudySession.find(params[:id])
    @session_file = @study_session.prepare_session(current_user)
    raise User::NotAuthorized unless @study_session.joinable_by?(current_user)
    @token = @study_session.generate_token(current_user)
    @show = true
    
    ether = EtherpadLite.connect('staging01.c45577.blueboxgrid.com:9001', '
WTMWI8sTBWnpthKl1o6KUSe9rN4O6zq6')
    # Get the EtherpadLite Group and Pad by id
    @etherpad_group = ether.group(@study_session.id)
    @pad = @etherpad_group.get_pad(@study_session.id)
    author = ether.author("my_app_user_#{current_user.id}", :name => current_user.name)
      # Get or create an hour-long session for this Author in this Group
    if session[:ep_sessions][@etherpad_group.id] == nil
      sess = @etherpad_group.create_session(author, 60)
    else
      sess = ether.get_session(session[:ep_sessions][@etherpad_group.id])
    end 
    if sess.expired?
      sess.delete
      sess = @etherpad_group.create_session(author, 60)
    end
      session[:ep_sessions][@etherpad_group.id] = sess.id
      # Set the EtherpadLite session cookie. This will automatically be picked up by the jQuery plugin's iframe.
      cookies[:sessionID] = {:value => sess.id}
  end
  
  def new
    @modal_link_id = params[:link_id]
    @study_session = StudySession.new
    @study_session.buddy_ids = [params[:id]]
    #Recommendation.connect_new(current_user.id, @study_session.buddy_ids, 5)
    @study_session.session_files.build
    #@faqs_page = StaticPage.find_by_slug(:faqs)
    respond_to do |format|
      if params[:calendar]
        format.js {render "calendar"}
      else
        format.js
      end
    end
  end
  
  def create
    @study_session = current_user.study_sessions.new(params[:study_session])
    @study_session.init_opentok
    buddyids = params[:study_session][:buddy_ids]
    buddyids.shift
    buddyids_w_current = [current_user.id.to_s] + buddyids
    Recommendation.populate_user(buddyids_w_current)
    Recommendation.connect_new(current_user.id, buddyids, 1)
    #Recommendation.list_all
    if @study_session.calendar?
      @study_session.addtocalendar
      if @study_session.save
        #push_broadcast :studyhall_created, :name => @study_session.name
        @local_cal = current_user.calendars.new
        @local_cal.update_attributes({ :date_start => @study_session.time_start, :time_start => @study_session.time_end, :schedule_id => @study_session.id })
        redirect_to calendars_url, :notice => "Study session '#{@study_session.name}' scheduled successfully for #{@study_session.time_start} at #{@study_session.time_end}."
      else
        render action: 'new'
      end
    elsif @study_session.save
      #Connect to etherpadlite instance - please see http://jordanhollinger.com/docs/ruby-etherpad-lite/ for detailed documentation
      #args are host, APIKEY
      ether = EtherpadLite.connect('staging01.c45577.blueboxgrid.com:9001', '
WTMWI8sTBWnpthKl1o6KUSe9rN4O6zq6')
      #Create etherpad group
      @etherpad_group = ether.create_group({:mapper => @study_session.id})
      @pad = @etherpad_group.create_pad(@study_session.id, {:text => ' '})
      #push_broadcast :studyhall_created, :name => @study_session.name
      redirect_to @study_session
    else
      render action: 'new'
    end
  end

  def update
    @study_session = current_user.study_sessions.find(params[:id])
    @study_session.update_attributes(params[:study_session])
    if params[:source] == "show_view"
      redirect_to @study_session
    else
      redirect_to study_sessions_path
    end
  end
  
  def destroy
    @study_session.destroy(params[:id])
    redirect_to study_sessions_path
  end
  
  private
  
  def find_study_sessions
    if params[:filter]
      @filtered_results = true
      flash.now[:action_bar_message] = "Filtered StudyHalls "
      study_sessions = StudySession.filter(params[:filter], current_user)
    else
      @filtered_results = false
      study_sessions = current_user.study_sessions
    end
    study_sessions
  end

  def augment_study_session_params
    params[:study_session] ||= {}
    params[:study_session][:remote_addr] = request.remote_addr
    params[:study_session][:user_id] = current_user.id
  end

end

