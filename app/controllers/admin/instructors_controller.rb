class Admin::InstructorsController < ApplicationController
  # GET /admin/instructors
  # GET /admin/instructors.json
  def index
    @admin_instructors = Admin::Instructor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_instructors }
    end
  end

  # GET /admin/instructors/1
  # GET /admin/instructors/1.json
  def show
    @admin_instructor = Admin::Instructor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_instructor }
    end
  end

  # GET /admin/instructors/new
  # GET /admin/instructors/new.json
  def new
    @admin_instructor = Admin::Instructor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_instructor }
    end
  end

  # GET /admin/instructors/1/edit
  def edit
    @admin_instructor = Admin::Instructor.find(params[:id])
  end

  # POST /admin/instructors
  # POST /admin/instructors.json
  def create
    @admin_instructor = Admin::Instructor.new(params[:admin_instructor])

    respond_to do |format|
      if @admin_instructor.save
        format.html { redirect_to @admin_instructor, notice: 'Instructor was successfully created.' }
        format.json { render json: @admin_instructor, status: :created, location: @admin_instructor }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/instructors/1
  # PUT /admin/instructors/1.json
  def update
    @admin_instructor = Admin::Instructor.find(params[:id])

    respond_to do |format|
      if @admin_instructor.update_attributes(params[:admin_instructor])
        format.html { redirect_to @admin_instructor, notice: 'Instructor was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/instructors/1
  # DELETE /admin/instructors/1.json
  def destroy
    @admin_instructor = Admin::Instructor.find(params[:id])
    @admin_instructor.destroy

    respond_to do |format|
      format.html { redirect_to admin_instructors_url }
      format.json { head :ok }
    end
  end
end
