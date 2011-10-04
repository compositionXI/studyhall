class NotebooksController < ApplicationController

  #layout "full_width"

  before_filter :require_user
  before_filter :set_action_bar

  def index
    @notebooks = current_user.notebooks.all
    @unsorted_notes = current_user.notes.unsorted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notebooks }
    end
  end

  def show
    @notebook = Notebook.viewable_by(current_user).find(params[:id])
    @show = true

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notebook }
    end
  end

  def new
    @notebook = Notebook.new

    respond_to do |format|
      format.html do
        if request.xhr?
          render :partial => "form"
        else
          render "new"
        end
      end
      format.json { render json: @notebook }
    end
  end

  def edit
    @notebook = current_user.notebooks.find(params[:id])
  end

  def create
    @notebook = current_user.notebooks.new(params[:notebook])

    respond_to do |format|
      if @notebook.save
        format.html { redirect_to @notebook, notice: 'Notebook was successfully created.' }
        format.json { render json: @notebook, status: :created, location: @notebook }
      else
        format.html { render action: "new" }
        format.json { render json: @notebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @notebook = current_user.notebooks.find(params[:id])

    respond_to do |format|
      if @notebook.update_attributes(params[:notebook])
        format.html { redirect_to @notebook, notice: 'Notebook was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @notebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notebook = current_user.notebooks.find(params[:id])
    @notebook.destroy

    respond_to do |format|
      format.html { redirect_to notebooks_url }
      format.json { head :ok }
    end
  end
end
