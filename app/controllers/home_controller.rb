class HomeController < ApplicationController
  
  def index
    @notebooks = @current_user.notebooks
  end
end
