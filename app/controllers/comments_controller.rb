class CommentsController < ApplicationController
 
  before_filter :require_user
 
  def create
    @comment = Comment.new(params[:comment])
    @comment.offering_id = params[:class_id]
    @comment.user = current_user
    if @comment.save
      if request.xhr?
        render_posts
      end
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes params[:comment]
      Notifier.report_post(current_user, @comment).deliver if params[:reported]
      if request.xhr?
        render_posts
      end
    end
  end
  
  private
  
  def render_posts
    @posts = Offering.find(params[:class_id]).posts.recent.top_level
    render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts}
  end
end
