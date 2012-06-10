class CommentsController < ApplicationController
 
  before_filter :require_user
 
  def create
    @post_type = params[:post_type]
    @comment = Comment.new(params[:comment])
    if @post_type == 'group'
      @comment.group_id = params[:group_id]
    else
      @comment.offering_id = params[:class_id]
    end
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
    if @post_type == 'group'
      @posts = Group.find(params[:group_id]).posts.where("post_type <= ?", 'group').recent.top_level
    else
      @posts = Offering.find(params[:class_id]).posts.where("post_type <= ?", 'class').recent.top_level
    end
    render :partial => '/posts/list_item.html.erb', :locals => {:posts => @posts, :post_type => @post_type}
  end
end
