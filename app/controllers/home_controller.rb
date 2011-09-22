class HomeController < ApplicationController
  
  def index
    @notebooks = @current_user.notebooks
    @unsorted_notes = @current_user.notes.unsorted
  end
end
