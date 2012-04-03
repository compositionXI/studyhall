class MemberRequestsController < ApplicationController

  before_filter :require_user
  before_filter :set_action_bar

  def place
    if MemberRequest.where(:user_id => current_user.id, :group_id => params[:group_id], :answered =>false).length == 0
      MemberRequest.create({:user_id => current_user.id, :group_id => params[:group_id], :answered => false, :accepted => false})
      @link_id = params[:link_id]
      respond_to do |format|
        format.js
        format.json {}
      end
    end
  end

  def answer
    @request = MemberRequest.find(params[:request_id])
    @accept = params[:accept] == "true"
    @link_id = params[:link_id]
    if @request
      @request.update_attribute(:answered, true)
      @request.update_attribute(:accepted, @accept)
      @request.group.members << @request.user if @accept
    end
    @n_pending = @request.group.unanswered_member_requests.length
    respond_to do |format|
      format.js
    end
  end
end
