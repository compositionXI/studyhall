class StudySessionsController < ApplicationController
  
  before_filter :require_user
  before_filter :set_action_bar, except: [:show]
  before_filter :augment_study_session_params, only: [:create, :update]
  
  def index
    @study_sessions = current_user.study_sessions
    @index = true
  end
  
  def show
    @study_session = StudySession.find(params[:id])
    raise User::NotAuthorized unless @study_session.joinable_by?(current_user)
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
    redirect_to @study_session
  end
  
  def destroy
    @study_session.destroy(params[:id])
    redirect_to study_sessions_path
  end
  
  private
  
  def augment_study_session_params
    params[:study_session] ||= {}
    params[:study_session][:remote_addr] = request.remote_addr
    params[:study_session][:user_id] = current_user.id
  end

end
