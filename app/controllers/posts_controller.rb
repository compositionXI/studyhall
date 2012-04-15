class PostsController < ApplicationController
  
  def index
    # get matching user
    # if user, look for that user's posts, else all posts for that class
    # then looks for posts with those post params 
    # TODO refactor
    # @users, @users_with_extras = [], []
    # @users = User.where(params[:user]) if params[:user]
    # @users_with_extras = User.has_extracurricular(params[:extracurricular_id].first.to_i) if params[:extracurricular_id]
    # @users = @users.concat(@users_with_extras)
    # @users = User.where(params[:user])
    if params[:user]
      sport_id = params[:user].delete(:sport_id)
      frat_sorority_id = params[:user].delete(:frat_sorority_id)
      @users = User.where(params[:user])
      @users = @users.has_sports([sport_id]) if sport_id
      @users = @users.has_frat_sororities([frat_sorority_id]) if frat_sorority_id
    end
    
    @class = Offering.find params[:class_id]
    @posts = []
    if @users
      @users.each do |user|
        @posts << Post.for_offering(@class).by_user(user).where(params[:post]).recent.top_level
      end
    else
      @posts = Postf.where(params[:post]).recent.top_level
    end
    render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts.flatten}
  end
  
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
      push_broadcast :class_post, :course_id => @post.offering.course_id, :name => @post.offering.course.title
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
  
  def filter
    @modal_link_id = params[:link_id]
    @class = Offering.find params[:class_id], :include => :posts
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def render_posts
    @posts = Offering.find(params[:class_id]).posts.recent.top_level
    render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts}
  end
end
