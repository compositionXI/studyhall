class CalendarsController < ApplicationController

  before_filter :require_user
  before_filter :set_action_bar, except: [:show]

  # GET /calendars
  # GET /calendars.json
  def index
    #@calendars = Calendar.all
    @user_cals = Calendar.other_user_json(current_user)
    if(params[:new_schedule] == 1)
      flash.now[:notice] = "Studyhall #{params[:schedule_name]} scheduled successfully."
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js { render "index" }
      #format.json { render json: @calendars }
    end
  end
=begin
  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.json
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(params[:calendar])

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render json: @calendar, status: :created, location: @calendar }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # PUT /calendars/1
  # PUT /calendars/1.json
  def update
    @calendar = Calendar.find(params[:id])
    respond_to do |format|
      @calendar.update_attributes({ :date_start => params[:newDate], :time_start => params[:newTime] })
        format.html { redirect_to calendars_url, notice: 'Calendar was successfully updated.' }
    end
  end

=begin
  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :no_content }
    end
  end
=end

end
