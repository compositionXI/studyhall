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
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group_post }
    end
  end
  
  def create
    @post_type = params[:post_type]
    @class = Offering.find params[:class_id]
    @post = Post.new
    @post.user_id = current_user.id
    @post.text = params[:message]
    @post.reported = 0
    if @post_type == 'group'
      @post.post_type = 'group'
      @post.group_id = params[:class_id]
    else
      @post.post_type = 'class'
      @post.offering_id = params[:class_id]
    end
    if @post.save
      if @post_type == 'group'
        redirect_to "/groups/#{params[:class_id]}"
      else
        redirect_to "/classes/#{@class.to_param}" 
      end 
      #push_broadcast :class_post, :class_id => @post.offering_id, :name => @post.offering.course.title
#      if request.xhr?
#        render_posts
#      end
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
    if @post_type == 'group'
      @posts = Group.find(params[:class_id]).posts.where("post_type <= ?", 'group').recent.top_level
    else
      @posts = Offering.find(params[:class_id]).posts.where("post_type <= ?", 'class').recent.top_level
    end
    render :partial => 'posts/list_item.html.erb', :locals => {:posts => @posts, :post_type => params[:post_type]}
  end
end
