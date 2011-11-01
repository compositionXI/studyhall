module ApplicationHelper
  def items_layout
    params[:layout].presence || 'grid'
  end
  
  def logged_in?
    @current_user
  end

  def inbox_count
    count = 0
    current_user.inbox.each do |m|
      count += 1 unless m.opened?
    end
    count > 0 ? count > 99 ? "*" : count : ""
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
