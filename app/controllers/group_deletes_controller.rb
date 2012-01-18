class GroupDeletesController < ApplicationController
  
  include ActionView::Helpers::TextHelper

  def new
    @group_delete = GroupDelete.new(class_name: params[:class_name])
  end

  def create
    @group_delete = GroupDelete.new(params[:group_delete])
    if @group_delete.process
      flash[:notice] = "Deleted #{pluralize(@group_delete.object_ids_array.size,@group_delete.object_title)}"
    else
      flash[:warning] = "Uh-oh! There was a problem. Please try again."
    end
    redirect_to request.referrer
  end

end
