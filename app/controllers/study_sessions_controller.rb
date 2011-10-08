class StudySessionsController < ApplicationController
  
  before_filter :init_opentok, :only => ["show", "create"]
  before_filter :set_action_bar
  
  def index
    @study_sessions = StudySession.all
  end
  
  def show
    @study_session = StudySession.find(params[:id])
    @room = Room.find(@study_session.room_id)
  end
  
  def new
    @study_session = StudySession.new
    @room = Room.new
    @whiteboard = Whiteboard.new
    
    respond_to do |format|
      format.html do
        if request.xhr?
          render :partial => "form"
        else
          render "new"
        end
      end
      @modal_link_id = params[:link_id]
      format.js
    end
  end
  
  def create
    session = @opentok.create_session request.remote_addr
    @room = Room.new
    @room.sessionId = session.session_id
    @room.save
    @whiteboard = Whiteboard.new()
    @whiteboard.save
    @study_session = StudySession.new(params[:study_session])
    @study_session.whiteboard_id = @whiteboard.id
    @study_session.room_id = @room.id
    @study_session.save
    redirect_to study_session_path(@study_session.id)
  end
  
  def destroy
    @study_session = StudySession.find params[:id]
    @study_session.destroy
    redirect_to study_sessions_path
  end
  
  private
  
  def init_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTokSDK.new 3277692, "8905050f8367fa22748f910906d6a1dfe3b035f8"
    end
  end
end
