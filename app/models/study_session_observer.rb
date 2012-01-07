class StudySessionObserver < ActiveRecord::Observer
  observe :study_session

  def after_create(study_session)
    study_session.users.each do |user|
      next if study_session.user == user
      message_body = ActivityRenderer.new.generate_message(user, 'studyhall_invite', :inviter => study_session.user, :studyhall => study_session)
      ActivityMessage.create(:user => user, :body => message_body, :activist => study_session.user)
    end
  end
end
