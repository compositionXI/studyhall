class FollowingsController < ApplicationController

  before_filter :require_user

  def create
    following = current_user.followings.create(:followed_user_id => params[:followed_user_id], :user_id => current_user.id)
    @success = following.valid?
  end

  def destroy
    following = current_user.followings.where(:id => params[:id]).first
    @success = Following.destroy(following.id)
  end

end
