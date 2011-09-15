class Admin::OfferingsController < ApplicationController
  
  layout "admin"
  
  def index
    @offerings = Offering.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @offering = Offering.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @offering = Offering.find(params[:id])
  end

  def create
    @offering = Offering.new(params[:offering])

    respond_to do |format|
      if @offering.save
        format.html { redirect_to admin_offerings_path, notice: 'Offering was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @offering = Offering.find(params[:id])

    respond_to do |format|
      if @offering.update_attributes(params[:offering])
        format.html { redirect_to admin_offerings_path, notice: 'Offering was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @offering = Offering.find(params[:id])
    @offering.destroy

    respond_to do |format|
      format.html { redirect_to admin_offerings_url }
    end
  end
end