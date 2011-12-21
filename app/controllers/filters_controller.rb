class FiltersController < ApplicationController

  def new
    @filter_form = params[:model_name].tableize + "_form"
    @filter = Filter.new(:model_name => params[:model_name])
  end

  def create
    @filter = Filter.new(params[:filter])
    redirect_to @filter.to_query
  end

end
