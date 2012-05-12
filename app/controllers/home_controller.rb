class HomeController < ApplicationController

  before_filter :require_user, only: [:index]

  caches_page :landing_page, :privacy, :terms, :faqs, :about
  
  def index
    #@notebooks = @current_user.notebooks
    #@unsorted_notes = @current_user.notes.unsorted
    @enrollment = Enrollment.new
    #@offerings = current_user.school.offerings.includes(:course, :instructor)
    @user = @current_user
    unless current_user.profile_complete?
      flash.now[:notice] = "Your profile is #{current_user.profile_completion_percentage}% complete!"
    end
    check_tour_mode
  end
  
  def privacy
  end

  def terms
  end

  def faqs
  end

  def about
  end

  def ping
    Rails.cache.fetch('ping') do
      @ping = RssEntry.first
    end
  end

  def landing_page
    @user = User.new
    render layout: "landing"
  end

  protected
    
    def check_tour_mode
      @tour = true if params[:tour] == 'true'
    end
end
