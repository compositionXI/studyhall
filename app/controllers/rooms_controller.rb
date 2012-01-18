class RoomsController < ApplicationController
  
  before_filter :init_opentok, :only => ["show", "create"]
  before_filter :fetch_room, :only => [:show, :edit, :destroy]
  
  def index
    @rooms = Room.where(:public => true)
  end

  def new
    @room = Room.new
  end

  def create
    session = @opentok.create_session request.remote_addr
    params[:room][:sessionId] = session.session_id
    @room = Room.new(params[:room])

    if @room.save
      redirect_to room_path(@room)
    else
      flash[:notice] = "The room could not be created!"
      render "new"
    end
  end

  def show
    @tok_token = @opentok.generate_token :session_id => @room.sessionId
  end
  
  def destroy
    @room.destroy
    flash[:notice] = "Room has been deleted!"
    redirect_to "index"
  end

  private
    def fetch_room
      @room = Room.find(params[:id])
    end
    def init_opentok
      if @opentok.nil?
        @opentok = OpenTok::OpenTokSDK.new 3277692, "8905050f8367fa22748f910906d6a1dfe3b035f8"
      end
    end
end
