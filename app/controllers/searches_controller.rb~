class SearchesController < ApplicationController
  before_filter :set_action_bar, :only => [:show]

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
  
  def sort
    @type = params[:type]
    @field = params[:options]
    @keywords = params[:keywords]
    if @type = 'notes'
      @search = Note.search do 
        fulltext params[:keywords]
        if @field == 'name'
          order_by :name, :asc
        elsif @field == 'owner' 
          order_by :owner_name, :asc
        elsif @field == 'course'
          order_by :course_name, :asc
        else
          order_by :created_at, :asc
        end
        paginate :page => 1, :per_page => 5
      end
      if @field == 'name'
        @sorted = @search.results.sort_by {|note| note.name}
      elsif @field == 'owner'
        @sorted = @search.results.sort_by {|note| note.owner.last_name}
      elsif @field == 'course'
        @sorted = @search.results.sort_by {|note| note.course.title}
      else 
        @sorted = @search.results.sort_by {|note| note.created_at}
      end
    end
    debugger
    respond_to do |format|
      format.html {render @type}
      format.js 
    end
  end 
  def autocomplete
    @search = Sunspot.search Course, User do
      fulltext params[:keywords]
      paginate :page => 1, :per_page => 5
    end
    @search2 = Sunspot.search Note do
      fulltext params[:keywords]
      paginate :page => 1, :per_page => 5
    end
    result1 = @search.results.map { |r| 
      h = {}
      case r.class.name
      when 'Course'
        h[:type] = "Course"
        h[:label] = truncate(r.title, :length => 30)
        h[:value] = r.title
      when 'User'
        h[:type] = "User"
        h[:label] = truncate(r.name, :length => 30)
        h[:value] = r.name
      end
      h
    }
    result2 = @search2.results.map { |r|
      h = {}
      h[:type] = "Note"
      h[:label] = truncate(r.name, :length => 30)
      h[:value] = r.name
      h
    }
    result = result1.concat(result2)
    render :json => result.to_json
  end
end
