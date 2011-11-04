class FollowingsController < ApplicationController

  before_filter :require_user

  def create
    followed_user = User.find(params[:followed_user_id])
    if followed_user
      following = current_user.follow!(followed_user)
      @success = following.valid?
      followed_user.deliver_followed_notification!(current_user) if followed_user.notify_on_follow? and @success
      render :json => @success
    end
  end

  def destroy
    @success = current_user.unfollow!(nil,{:followed_user_id => params[:id]})
    render :json => (@success == 1)
  end

end
