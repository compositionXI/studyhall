class FaqsController < ApplicationController
  
  before_filter :require_admin, :except => [:index]
  before_filter :fetch_faq, :only => [:show, :edit, :update, :destroy]
  
  def index
    @faqs = Faq.all
  end

  def show
  end

  def new
    @faq = Faq.new
  end

  def edit
  end

  def create
    @faq = Faq.new(params[:faq])

    if @faq.save
      redirect_to @faq, notice: 'Faq was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @faq.update_attributes(params[:faq])
      redirect_to @faq, notice: 'Faq was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @faq.destroy
  end
  
  private
  def fetch_faq
    @faq = Faq.find(params[:id])
  end
end