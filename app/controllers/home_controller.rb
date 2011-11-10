class HomeController < ApplicationController

  before_filter :require_user, only: [:index]

  def index
    @notebooks = @current_user.notebooks
    @unsorted_notes = @current_user.notes.unsorted
    unless current_user.profile_complete?
      flash.now[:notice] = "Your profile is #{current_user.profile_completion_percentage}% complete!"
    end
  end

  def landing_page
    @user = User.new
    render layout: "landing"
  end

end
