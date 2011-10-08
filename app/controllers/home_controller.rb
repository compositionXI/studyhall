class HomeController < ApplicationController

  def index
    @notebooks = @current_user.notebooks
    @unsorted_notes = @current_user.notes.unsorted
    unless current_user.profile_complete?
      flash[:notice] = "Your profile is only #{current_user.profile_completion_percentage}% complete!"
    end
  end
end