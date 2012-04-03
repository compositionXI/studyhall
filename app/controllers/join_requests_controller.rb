class JoinRequestsController < ApplicationController

  

  # GET /join_requests
  # GET /join_requests.json
  def index
    @join_requests = JoinRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @join_requests }
    end
  end

  # GET /join_requests
  # GET /join_requests.json
  def perform
    @join_requests = JoinRequest.all

    respond_to do |format|
      format.html {"index"}
      format.json { render json: @join_requests }
    end
  end

  # GET /join_requests/1
  # GET /join_requests/1.json
  def show
    @join_request = JoinRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @join_request }
    end
  end

  # GET /join_requests/new
  # GET /join_requests/new.json
  def new
    @join_request = JoinRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @join_request }
    end
  end

  # GET /join_requests/1/edit
  def edit
    @join_request = JoinRequest.find(params[:id])
  end

  # POST /join_requests
  # POST /join_requests.json
  def create
    @join_request = JoinRequest.new(params[:join_request])

    respond_to do |format|
      if @join_request.save
        format.html { redirect_to @join_request, notice: 'Join request was successfully created.' }
        format.json { render json: @join_request, status: :created, location: @join_request }
      else
        format.html { render action: "new" }
        format.json { render json: @join_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /join_requests/1
  # PUT /join_requests/1.json
  def update
    @join_request = JoinRequest.find(params[:id])

    respond_to do |format|
      if @join_request.update_attributes(params[:join_request])
        format.html { redirect_to @join_request, notice: 'Join request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @join_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /join_requests/1
  # DELETE /join_requests/1.json
  def destroy
    @join_request = JoinRequest.find(params[:id])
    @join_request.destroy

    respond_to do |format|
      format.html { redirect_to join_requests_url }
      format.json { head :no_content }
    end
  end
end
