class VotesController < ApplicationController

  before_filter :find_user

  def create
    Vote.transaction do
      Vote.destroy(@user.votes.where(:voter_id => current_user).map(&:id))
      current_user.vote_for(@user)
    end
  end
    
  def destroy
    Vote.transaction do
      Vote.destroy(@user.votes.where(:voter_id => current_user).map(&:id))
      current_user.vote_against(@user)
    end
  end

  def find_user
    @user = User.find(params[:user_id])
  end

end
