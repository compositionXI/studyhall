module ApplicationHelper
  def items_layout
    params[:layout].presence || 'grid'
  end
  
  def logged_in?
    @current_user
  end

  def inbox_count
    count = 0
    current_user.all_messages.each do |m|
      count += 1 unless m.opened?
    end
    
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
      
end
