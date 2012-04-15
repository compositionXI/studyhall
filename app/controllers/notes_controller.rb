class NotesController < ApplicationController

  layout "full_width"

  before_filter :require_user
  before_filter :find_note, except: [:index, :request_access]
  before_filter :set_action_bar
  before_filter :find_notebook

  def index
    if @notebook
      @note_items = NoteItem.init_set(@notebook.notes)
    else
      @note_items = NoteItem.init_set(Backpack.new(current_user).contents(page: params[:page], filter: params[:filter]))
      @documents = Array.new
      types = CSV.read("db/doc_types.csv").unshift ["All", "0"]
      types.each do |type|
        @documents << NoteItem.init_set(Backpack.new(current_user).contents(page: params[:page], filter: params[:filter], doc_type: type[1]))
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  def show
    respond_to do |format|
      format.html {
        redirect_to notes_path, alert: "The Note you try to visit is not allowed to view or not exist!"  and return if @note.new_record?
      }
      format.json { render json: @note }
    end
  end

  def new
    @note = @notebook ? @notebook.notes.build : Note.new
    @group = params[:group]
    @modal_link_id = params[:link_id]
    @remote = false
    respond_to do |format|
      format.html { render "edit" }
      format.json { render json: @note }
      if params[:upload]
        format.js {render "upload"}
      else
        format.js
      end
    end
  end

  def edit
    if(params[:id])
      @note = current_user.notes.find(params[:id])
      if params[:upload]
        @note = params[:upload]
      end
      @modal_link_id = params[:link_id]
      @remote = params[:source].present?
      respond_to do |format|
        format.js
        format.html
      end
    else
      @file = params[:upload][:file]
      @note = UploadUtils::upload(@file, current_user)
      respond_to do |format|
        format.html
        format.json { render json: @note }
      end
    end
  end

  def create
    @note = current_user.notes.new(params[:note])
    logger.info("LIZZY: #{params[:note][:group_ids]}!")
    if !@note.share_choice
      @note.users = []
      @note.groups = []
    end
    if @note.upload == "true"
      @note = UploadUtils::upload(@note)
      respond_to do |format|
        if @note.save
          if @note.doc_preserved
            format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
          else
            format.html { redirect_to @note, notice: 'Note was successfully created.' }
          end
          format.json { render json: @note, status: :created, location: @note }
        else
          format.html { render action: :edit }
          format.json { render json: @note.errors, status: :unprocessable_entity }
        end
      end
    else
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
  end

  def update
    @note = current_user.notes.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        @note.set_notebook_shareable
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
      @note.sharable = @notebook.shareable
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

  def request_access
    @note = Note.find(params[:id])
    Notifier.request_note_access(current_user, @note).deliver
    render :nothing => true
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
