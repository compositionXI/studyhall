class SearchesController < ApplicationController
  
  def create
    @search = Search.new(params[:search])
    @search.process(:page => params[:page])
    @results = @search.results
  end

end
