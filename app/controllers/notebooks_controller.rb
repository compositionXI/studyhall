class NotebooksController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :set_action_bar
  before_filter :get_notebooks_and_notes, :only => [:index]

  def index
    if params[:edit_all] == "true"
      @edit_all = true
    else
      @index = true
    end
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
      format.js
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
  
  def delete_multiple
    if params[:notebook_ids]
      @notebooks = current_user.notebooks.find(params[:notebook_ids])
      @notebooks.each {|notebook| notebook.destroy}
    end
    if params[:note_ids]
      @notes = current_user.notes.find(params[:note_ids])
      @note.each {|note| note.destroy}
    end
    
    get_notebooks_and_notes
    if request.xhr?
      @index = true
      render "index"
    end
  end
  
  private
  
  def get_notebooks_and_notes
    @notebooks = current_user.notebooks
    @unsorted_notes = current_user.notes.unsorted
  end
end
