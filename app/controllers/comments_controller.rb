class CommentsController < ApplicationController
 
  before_filter :require_user
 
  def create
    @comment = Comment.new(params[:comment])
    @comment.offering_id = params[:class_id]
    @comment.user = current_user
    if params[:group_post]
      @post.post_type = 'group'
    else
      @post.post_type = 'class'
    end
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
    if params[:group_post]
      @posts = Offering.find(params[:class_id]).posts.where("post_type <= ?", 'class').recent.top_level
    else
      @posts = Offering.find(params[:class_id]).posts.where("post_type <= ?", 'group').recent.top_level
    end
    render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts}
  end
end
