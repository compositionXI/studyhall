class HomeController < ApplicationController

  before_filter :require_user, only: [:index]

  def index
    @notebooks = @current_user.notebooks
    @unsorted_notes = @current_user.notes.unsorted
    unless current_user.profile_complete?
      flash[:notice] = "Your profile is #{current_user.profile_completion_percentage}% complete!"
    end
  end

  def landing_page
    @user = User.new
    render layout: "landing"
  end

  private

  def pretty_time_label(time)
    today = DateTime.current.beginning_of_day
    if time.today?
      "Today"
    elsif time < today && time > today.ago(24*60*60)
      "Yesterday"
    else
      time.strftime("%B %d")
    end
  end

end
