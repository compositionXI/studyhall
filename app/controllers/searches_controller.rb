class SearchesController < ApplicationController
  
  def create
    if params[:search][:keywords].present?
      @search = current_user.searches.create!(params[:search])
    else
      redirect_to :back
    end
  end

end
