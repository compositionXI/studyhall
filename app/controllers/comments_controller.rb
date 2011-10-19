class CommentsController < ApplicationController
  
  def create
    @comment = Comment.create(params[:comment])
    @comment.offering_id = params[:class_id]
    @comment.user_id = current_user.id
    if @comment.save
      if request.xhr?
        @posts = Offering.find(params[:class_id]).posts.recent.top_level
        render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts}
      end
    end
  end
  
end
