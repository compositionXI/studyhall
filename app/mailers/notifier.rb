class Notifier < ActionMailer::Base
  default :from => 'no-reply@example.com', :return_path => 'system@example.com'
  
  default_url_options[:host] = "localhost:3000"

  def activation_instructions(user)
    @user = user
    @url = activate_url(@user.perishable_token)

    mail(
      :subject => "Activation Instructions",
      :from => "noreply@studyhall.com",
      :to => @user.email
    )
  end
  
  def welcome(user)
    @user = user
    @url = login_url
    mail(
      :subject => "Welcome to StudyHall",
      :from => "noreply@studyhall.com",
      :to => @user.email,
      :bcc => ["bcc@example.com", "Order Watcher <watcher@example.com>"]
    )
  end

  def password_reset_instructions(user)
    @user = user
    @url = edit_password_reset_url(@user.perishable_token)
    mail(
      :subject => "Password Reset Instructions",
      :from => "noreply@studyhall.com",
      :to => @user.email,
      :date => Time.now
    )
  end

  def study_session_invite(sender, user, session_invite)
    @user, @sender, @message = user, sender, session_invite.message
    @url = study_session_url(session_invite.study_session)
    mail(
      :subject => "#{sender.name} has invited you to a StudyHall",
      :from => "noreply@studyhall.com",
      :to => user.email,
      :date => Time.now
    )
  end
end
