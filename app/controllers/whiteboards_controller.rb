class WhiteboardsController < ApplicationController

  def index
    @whiteboards = Whiteboard.all
  end

  def new
    @whiteboard = Whiteboard.new
    render :layout => "blank"
  end

  def create
    @whiteboard = Whiteboard.new(params[:whiteboard])
    if @whiteboard.save && @whiteboard.prepare_embed!
      redirect_to @whiteboard.study_session
    else
      render :action => :new
    end
  end

  def show
    @whiteboard = Whiteboard.find(params[:id])
  end

  def edit
    @whiteboard = Whiteboard.find(params[:id])
  end

  def update
    @whiteboard = Whiteboard.find(params[:id])
    if @whiteboard.update_attributes(params[:whiteboard])
      redirect_to @whiteboard
    else
      render :action => :new
    end
  end

end
