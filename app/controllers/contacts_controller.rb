class ContactsController < ApplicationController

  before_filter :require_admin, :except => [:new, :create]
  before_filter :fetch_contact, :only => [:show, :edit, :update, :destroy]
  layout "contact" 

  def index
    redirect_to :action => :new
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if verify_recaptcha(:model => @contact, :message => "Oh! It's error with reCAPTCHA!") && @contact.save
      redirect_to root_path, notice: 'Contact was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @contact.update_attributes(params[:contact])
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end
  
  private
  def fetch_contact
    @contact = Contact.find(params[:id])
  end
end
