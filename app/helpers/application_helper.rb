module ApplicationHelper
  def items_layout
    params[:layout].presence || 'grid'
  end
  
  def logged_in?
    @current_user
  end

  def inbox_count
    count = current_user.all_messages({:deleted => false}).select {|m| !message_opened?(m)}.count
    
    case count
    when count > 99
      "*"
    when 0
      ""
    else
      count
    end
  end
  
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
  
  def inbox_class
      inbox_count > 0 ? 'no_messages' : 'messages'
  end

  def activate(active_key, key)
    active_key == key ? " active" : ""
  end

  def custom_url(user)
    "www.studyhall.com/" + user.custom_url
  end
   
  def user_missing
    "No Longer A User"
  end
   
end
