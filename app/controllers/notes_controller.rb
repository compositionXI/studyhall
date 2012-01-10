class NotesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_note, except: [:index]
  before_filter :set_action_bar
  before_filter :find_notebook

  def index
    if @notebook
      @note_items = NoteItem.init_set(@notebook.notes)
    else
      @note_items = NoteItem.init_set(Backpack.new(current_user).contents(page: params[:page], filter: params[:filter]))
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
    @note = @notebook ? @notebook.notes.build : Note.new
    @modal_link_id = params[:link_id]
    @remote = false
    respond_to do |format|
      format.html { render "edit" }
      format.js
      format.json { render json: @note }
    end
  end

  def edit
    @note = current_user.notes.find(params[:id])
    @modal_link_id = params[:link_id]
    @remote = params[:source].present?
    respond_to do |format|
      format.js
      format.html
    end
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
        format.js {}
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    if @notebook && @notebook.id != @note.notebook_id
      @note.notebook_id = @notebook.id
    else
      #Move the note out of a notebook
      @note.notebook_id = nil
    end

    respond_to do |format|
      if @note.save
        @notebook.reload
        format.json do
          if @note.notebook
            html = render_to_string(partial: 'notes/child_note.html.erb', locals: { note_item: NoteItem.new(@notebook), note: @note })
          else
            html = render_to_string(partial: 'notes/note_item.html.erb', locals: { note_item: NoteItem.new(@note) })
          end
          render json: { html: html }
        end
      else
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def delete
    @note = current_user.notes.find(params[:id])
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
      @note = Note.viewable_by(current_user).find_by_id(params[:id]) || Note.new
    end

    def find_notebook
      @notebook = Notebook.viewable_by(current_user).find_by_id(params[:notebook_id]) || @note.try(:notebook)
      if @note && @note.notebook_id.nil?
        @note.notebook = @notebook
      end
    end

    def set_action_bar
      return true unless action_name == "index"
      @action_bar = File.exists?("app/views/#{params[:controller]}/_action_bar.html.erb") ? "#{params[:controller]}/action_bar" : nil
      flash[:action_bar_message] ||= nil
    end
end
