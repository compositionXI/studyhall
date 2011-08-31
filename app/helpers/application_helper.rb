module ApplicationHelper  
  def about_permalink
    @about_permalink = About.on_display.first.permalink
  end
end
