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
  end
  
  def new
    @modal_link_id = params[:link_id]
    @study_session = StudySession.new
    @study_session.buddy_ids = [params[:id]]
    @study_session.session_files.build
  end
  
  def create
    @study_session = current_user.study_sessions.new(params[:study_session])
    if @study_session.save
      redirect_to @study_session
    else
      render action: "new"
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
      study_sessions = current_user.study_sessions.where(params[:filter][:study_session])
      if params[:filter][:user_ids]
        users = User.where(:id => params[:filter][:user_ids]).all
        flash.now[:action_bar_message] << "with #{truncate(users.map(&:full_name).to_sentence, :length => 50)} "
        study_sessions = study_sessions.with_users(params[:filter][:user_ids])
      end
      if params[:filter][:start_date] && params[:filter][:end_date]
        study_sessions = study_sessions.in_range(params[:filter][:start_date], params[:filter][:end_date])
      end
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
