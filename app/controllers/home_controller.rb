class HomeController < ApplicationController

  before_filter :require_user, only: [:index]

  def index
    @notebooks = @current_user.notebooks
    @unsorted_notes = @current_user.notes.unsorted
    unless current_user.profile_complete?
      flash[:notice] = "Your profile is #{current_user.profile_completion_percentage}% complete!"
    end
    latest_entries = @current_user.school.rss_entries.limit(5).all
    @rss_entries = Hash.new
    while not latest_entries.empty?
      entry = latest_entries.first
      beginning_of_day_time = entry.pub_date.beginning_of_day
      entries = latest_entries.select {|item| item.pub_date.beginning_of_day == beginning_of_day_time }
      @rss_entries[pretty_time_label(entry.pub_date)] = entries
      latest_entries = latest_entries - entries
    end
  end

  def landing_page
    @user = User.new
    render layout: "landing"
  end

  private

  def pretty_time_label(time)
    today = DateTime.current.beginning_of_day
    "Today" if time.today?
    "Yesterday" if time < today && time > today.ago(24*60*60)
    time.strftime("%B %d")
  end

end
