class SearchesController < ApplicationController
  autocomplete :course, :title  before_filter :set_action_bar, :only => [:show]

  def create
    if params[:search][:keywords].present?
      @search = current_user.searches.create!(params[:search])
      redirect_to @search
    else
      redirect_to :back
    end
  end
  
  def show
    @search = Search.find_by_id(params[:id])
    if @search.any?
      flash[:action_bar_message] = "Search Results for '#{@search.keywords}'"
    else
      flash[:action_bar_message] = "No Results for '#{@search.keywords}'"
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
  
  include ActionView::Helpers::TextHelper
  
  def autocomplete
    @search = Search.autocomplete(params[:keywords])
    result = @search.results.map { |r| 
      h = {}
      case r.class.name
      when 'Note'
        h[:url] = note_path(r)
        h[:label] = truncate(r.name, :length => 30)
        h[:value] = r.name
      when 'Course'
        h[:url] = class_path(r)
        h[:label] = truncate(r.title, :length => 30)
        h[:value] = r.title
      when 'User'
        h[:url] = user_path(r)
        h[:label] = truncate(r.name, :length => 30)
        h[:value] = r.name
      end
      h
    }
    render :json => result.to_json
  end
end
