class AboutsController < ApplicationController

  before_filter :require_admin, :except => [:show]
  before_filter :fetch_about, :only => [:edit, :update, :destroy]

  def index
    @abouts = About.all
  end

  def show
    @about = About.find_by_display 1
    unless @about
      redirect_to root_path
    end
  end

  def new
    @about = About.new
  end

  def edit
  end

  def create
    @about = About.new(params[:about])
    @about.text = @about.text.gsub(/\n/,"<br />")

    if @about.save
      redirect_to @about, notice: 'About was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @about.update_attributes(params[:about])
      redirect_to @about, notice: 'About was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @about.destroy
    redirect_to abouts_path
  end
  
  private
  def fetch_about
    @about = About.find(params[:id])
  end
end
