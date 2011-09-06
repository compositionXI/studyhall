class StaticPagesController < ApplicationController
    

  def show
    if @current_user && @current_user.admin? && params[:id]
      @static_page = StaticPage.find(params[:id])
    else
      @static_page = StaticPage.find_by_slug(params[:path])
    end
    
    if @static_page
      respond_to do |format|
        format.html
      end
    else
      # FIXME: This should instead redirect to the 404 page.
      redirect_to :action => "index"
    end
  end

end
