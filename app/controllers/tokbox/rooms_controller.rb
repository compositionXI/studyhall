class Tokbox::RoomsController < ApplicationController
  
  layout "poc"

  before_filter :init_opentok, :only => ["show", "create"]
  
  def index
    @rooms = Poc::Room.where(:public => true)
    @new_room = Poc::Room.new
  end

  def new
    @room = Poc::Room.new
  end

  def create
    session = @opentok.create_session request.remote_addr
    params[:poc_room][:sessionId] = session.session_id
    @new_room = Poc::Room.new(params[:poc_room])

    if @new_room.save
      redirect_to tokbox_room_path(@new_room)
    else
      render :controller => 'rooms', :action => "index"
    end
  end

  def show
    @room = Poc::Room.find(params[:id])
    @tok_token = @opentok.generate_token :session_id => @room.sessionId
  end

  private
    def init_opentok
      if @opentok.nil?
        @opentok = OpenTok::OpenTokSDK.new 3277692, "8905050f8367fa22748f910906d6a1dfe3b035f8"
      end
    end
end
