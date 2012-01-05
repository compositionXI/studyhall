class SessionInvitesController < ApplicationController

  before_filter :require_user
  before_filter :find_study_session

  def new
    @session_invite = @study_session.session_invites.new(sender_id: current_user.id)
  end

  def create
    @session_invite = @study_session.session_invites.new(params[:session_invite])
    generate_invite_message
    @session_invite.save
  end

  private

  def find_study_session
    @study_session = current_user.study_sessions.find(params[:study_session_id])
  end

  def generate_invite_message
    study_session = @session_invite.study_session
    @session_invite.message = render_to_string :partial => "message", :locals => {:study_session => study_session, sender: current_user}
  end

end
