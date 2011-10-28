class SearchesController < ApplicationController
  
  def create
    @search = Search.new(params[:search])
    @search.models = params[:models]
    @search.process(:page => params[:page])
    @results = @search.results
  end

end
