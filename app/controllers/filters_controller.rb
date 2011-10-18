class FiltersController < ApplicationController

  def new
    @filter = Filter.new(:model_name => "study_sessions")
  end

  def create
    @filter = Filter.new(params[:filter])
    redirect_to @filter.to_query
  end

end
