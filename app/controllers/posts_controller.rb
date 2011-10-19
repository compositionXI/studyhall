class PostsController < ApplicationController
  def new
    @class = Offering.find params[:class_id]
    @post = @class.posts.new(:user_id => params[:user_id])
    @modal_link_id = "class_share_button"
    render "posts/new.js.erb"
  end
  
  def create
    @post = Post.create(params[:post])
    @post.offering_id = params[:class_id]
    @post.user_id = current_user.id
    if @post.save
      if request.xhr?
        render_posts
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes params[:post]
      Notifier.report_post(current_user, @post).deliver if params[:reported]
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