class Admin::StaticPagesController < StaticPagesController
  
  before_filter :require_admin
  before_filter :fetch_page, :only => [:edit, :update, :destroy]
  
  def index
    @static_pages = StaticPage.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @static_page = StaticPage.new

    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def create
    @static_page = StaticPage.new(params[:static_page])
    @static_page.text = @static_page.text.gsub(/\n/,"<br />")
    respond_to do |format|
      if @static_page.save
        format.html { redirect_to @static_page, notice: 'Static page was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @static_page.update_attributes(params[:static_page])
        format.html { redirect_to @static_page, notice: 'Static page was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @static_page.destroy

    respond_to do |format|
      format.html { redirect_to static_pages_url }
    end
  end
  
  private
  def fetch_page
    @static_page = StaticPage.find(params[:id])
  end
end
