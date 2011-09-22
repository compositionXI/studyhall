class NotesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_note, except: [:index]
  before_filter :find_notebook

  def index
    if @notebook
      @notes = @notebook.notes.all
    else
      @notes = current_user.notes.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  def new
    respond_to do |format|
      format.html { render action: :edit }
      format.json { render json: @note }
    end
  end

  def edit
    @note = current_user.notes.find(params[:id])
  end

  def create
    @note = current_user.notes.new(params[:note])

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @note = current_user.notes.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note = current_user.notes.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to ( @note.notebook ? notebook_path(@note.notebook.id) : notebooks_path ) }
    end
  end

  protected
  def find_note
    @note = current_user.notes.find_by_id(params[:id]) || Note.new
  end

  def find_notebook
    @notebook = current_user.notebooks.find_by_id(params[:notebook_id]) || @note.try(:notebook)
    if @note && @note.notebook_id.nil?
      @note.notebook = @notebook
    end
  end
end
