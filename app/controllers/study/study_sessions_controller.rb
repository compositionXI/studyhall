class Study::StudySessionsController < ApplicationController
  
  layout "poc"
  
  before_filter :init_opentok, :only => ["show", "create"]
  
  def index
    @study_sessions = Poc::StudySession.all
  end
  
  def show
    @study_session = Poc::StudySession.find(params[:id])
    @room = Poc::Room.find(@study_session.poc_room_id)
    @whiteboard = Poc::Whiteboard.find(@study_session.poc_whiteboard_id)
  end
  
  def new
    @study_session = Poc::StudySession.new
    @room = Poc::Room.new
    @whiteboard = Poc::Whiteboard.new
  end
  
  def create
    session = @opentok.create_session request.remote_addr
    @room = Poc::Room.new
    @room.sessionId = session.session_id
    @room.save
    @whiteboard = Poc::Whiteboard.new
    @whiteboard.save
    @study_session = Poc::StudySession.new(params[:poc_study_session])
    @study_session.poc_whiteboard_id = @whiteboard.id
    @study_session.poc_room_id = @room.id
    @study_session.save
    redirect_to study_study_session_path(@study_session.id)
  end
  
  private
  
  def init_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTokSDK.new 3277692, "8905050f8367fa22748f910906d6a1dfe3b035f8"
    end
  end
end
