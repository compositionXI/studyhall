class StaticPagesController < ApplicationController    

  caches_page :show

  def show
    find_page
    
    if @static_page
      respond_to do |format|
        format.html
      end
    else
      # FIXME: This should instead redirect to the 404 page.
      redirect_to :action => "index"
    end
  end

  def find_page
    if params[:id] =~ /^\d+$/
      @static_page = StaticPage.find(params[:id])
    else
      @static_page = StaticPage.find_by_slug(params[:id])
    end
  end

end
