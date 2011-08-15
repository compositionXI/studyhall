class Poc::WhiteboardsController < ApplicationController

  layout "poc"

  def index
    @whiteboards = Poc::Whiteboard.all
  end

  def new
    @whiteboard = Poc::Whiteboard.new
  end

  def create
    @whiteboard = Poc::Whiteboard.new(params[:poc_whiteboard])
    if @whiteboard.save
      redirect_to @whiteboard
    else
      render :action => :new
    end
  end

  def show
    @whiteboard = Poc::Whiteboard.find(params[:id])
  end

  def edit
    @whiteboard = Poc::Whiteboard.find(params[:id])
  end

  def update
    @whiteboard = Poc::Whiteboard.find(params[:id])
    if @whiteboard.update_attributes(params[:poc_whiteboard])
      redirect_to @whiteboard
    else
      render :action => :new
    end
  end

end
