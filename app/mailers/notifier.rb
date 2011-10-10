class Notifier < ActionMailer::Base
  default :from => 'no-reply@example.com', :return_path => 'system@example.com'
  
  default_url_options[:host] = "localhost:3000"

  def welcome(user)
    @user = user
    @url = login_url
    mail(
      :subject => "Welcome to StudyHall",
      :from => "StudyHall.com",
      :to => @user.email,
      :bcc => ["bcc@example.com", "Order Watcher <watcher@example.com>"]
    )
  end

  def password_reset_instructions(user)
    @user = user
    @url = edit_password_reset_url(@user.perishable_token)
    mail(
      :subject => "Password Reset Instructions",
      :from => "StudyHall.com",
      :to => @user.email,
      :date => Time.now
    )
  end
end
