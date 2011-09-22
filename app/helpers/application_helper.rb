module ApplicationHelper
  def items_layout
    params[:layout].presence || 'grid'
  end
end
