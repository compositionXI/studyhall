module ApplicationHelper
  def items_layout
    params[:layout].presence || 'grid'
  end
  
  def logged_in?
    @current_user
  end

  def inbox_count
    count = current_user.inbox.count
    count > 0 ? count > 99 ? "*" : count : ""
  end
end
