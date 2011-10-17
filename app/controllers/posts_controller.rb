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
        @posts = Offering.find(params[:class_id]).posts
        render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts}
      end
    end
  end
end
