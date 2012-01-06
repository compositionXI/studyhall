class Notifier < ActionMailer::Base
  add_template_helper(MessagesHelper)
  
  default :from => 'no-reply@studyhall.com', :return_path => 'system@studyhall.com'

  default_url_options[:host] = APP_CONFIG["host"]
  
  def sharing(sharing, object_type, user)
    @sharing = sharing
    @object_type = object_type
    @sender = user
    @object_urls_array = @sharing.objects.map {|o| [o,url_for(o)] }
    mail(
      subject: "#{user.name.titleize} shared something with you on Studyhall.com!",
      from: "noreply@studyhall.com",
      bcc: @sharing.recipient_emails,
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

  def study_session_invite(sender, send_to, study_session)
    @send_to, @sender = send_to, sender
    @url = study_session_url(study_session)
    mail(
      :subject => "#{sender.title_name} has invited you to a studyhall",
      :from => "noreply@studyhall.com",
      :to => @send_to.email,
      :date => Time.now
    )
  end
  
  def report_post(reporter, post)
    @reporter, @offender, @post = reporter, post.user, post
    @url = "http://#{APP_CONFIG['host']}#{rails_admin.show_path("posts", @post.id)}"
    mail(
      :subject => "#{reporter.title_name} reported a post.",
      :from => "noreply@studyhall.com",
      :to => "admin@studyhall.com",
      :date => Time.now
    )
  end
  
  def report_message(reporter, message)
    @offender =  User.find(message.is_a?(Message) ? message.sender_id : message.sent_messageable_id)
    @reporter, @message = reporter, message
    @url = "http://#{APP_CONFIG['host']}#{rails_admin.show_path(@message.class.to_s.tableize, @message.id)}"
    mail(
      :subject => "#{reporter.title_name} reported a post.",
      :from => "noreply@studyhall.com",
      :to => "admin@studyhall.com",
      :date => Time.now
    )
  end

  def user_following(user, followed_user)
    @follower, @followed = user, followed_user
    mail(
      :subject => "#{user.title_name} is following you.",
      :from    => "noreply@studyhall.com",
      :to      => followed_user.email,
      :date    => Time.now
    )
  end

  def new_comment(comment, commenter, author, post)
    @comment, @commenter, @author, @post = comment, commenter, author, post
    mail(
      :subject => "#{@commenter.name.titleize} just added new comment on your post.",
      :from    =>  "noreply@studyhall.com",
      :to      =>  author.email,
      :date    =>  Time.now
    )
  end

  def gmail_invite(name, message, recipient)
    @name, @message = name, message
    @url = root_url
    mail(
      subject: "#{@name.titleize} thinks you'd like studyhall",
      from:    'noreply@studyhall.com',
      to:      recipient,
      date:    Time.now
    )
  end

  def contact_form(contact)
    @contact = contact
    @url = "http://#{APP_CONFIG['host']}#{rails_admin.show_path('contacts', @contact.id)}"
    mail(
      subject: "StudyHall Contact Form from [#{@contact.name.titleize}]",
      from:    'noreply@studyhall.com',
      to:      APP_CONFIG['contact_form_recipient'],
      date:    Time.now
    )
  end
end
