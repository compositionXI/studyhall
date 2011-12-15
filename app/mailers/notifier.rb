class Notifier < ActionMailer::Base
  default :from => 'no-reply@studyhall.com', :return_path => 'system@studyhall.com'

  default_url_options[:host] = APP_CONFIG["host"]
  
  def sharing(sharing, user)
    @sharing = sharing
    @sender = user
    @object_urls_array = @sharing.objects.map {|o| [o,url_for(o)] }
    mail(
      subject: "#{user.name} wants to share with you",
      from: "noreply@studyhall.com",
      bcc: @sharing.email_addresses,
      date: Time.now
    )
  end

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
  
  def report_post(reporter, post)
    @reporter, @offender, @post = reporter, post.user, post
    mail(
      :subject => "#{reporter.name} reported a post.",
      :from => "noreply@studyhall.com",
      :to => "admin@studyhall.com",
      :date => Time.now
    )
  end
  
  def report_message(reporter, message)
     @reporter, @offender, @message = reporter, message.sender_id, message
      mail(
        :subject => "#{reporter.name} reported a post.",
        :from => "noreply@studyhall.com",
        :to => "admin@studyhall.com",
        :date => Time.now
      )
  end

  def user_following(user, followed_user)
    @follower, @followed = user, followed_user
    mail(
      :subject => "#{user.name} is following you.",
      :from    => "noreply@studyhall.com",
      :to      => followed_user.email,
      :date    => Time.now
    )
  end

  def new_comment(comment, commenter, author, post)
    @comment, @commenter, @author, @post = comment, commenter, author, post
    mail(
      :subject => "#{@commenter} add new comment on your post.",
      :from    =>  "noreply@studyhall.com",
      :to      =>  author.email,
      :date    =>  Time.now
    )
  end

  def gmail_invite(name, message, recipient)
    @name, @message = name, message
    @url = root_url
    mail(
      subject: "#{@name} thinks you'd like StudyHall",
      from:    'noreply@studyhall.com',
      to:      recipient,
      date:    Time.now
    )
  end

  def contact_form(contact)
    @contact = contact
    mail(
      subject: "StudyHall Contact Form from [#{@contact.name}]",
      from:    'noreply@studyhall.com',
      to:      CONTACT_FORM_RECIPIENT,
      date:    Time.now
    )
  end
end
