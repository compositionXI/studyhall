module MessagesHelper
  
  MSG_CUTOFF = 80
  SUBJECT_CUTOFF = 30
  
  def from_current_user(message)
    (message.from == current_user)
  end
  
  def to_from_user(message)
    from_current_user(message) ? message.to : message.from
  end
  
  def user_photo_for(message)
    user = to_from_user(message)
    link_to(image_tag(user.photo_url(:medium)), user, :title => user.name, :class => 'avatar')
  end
  
  def user_name_for(message)
    user = to_from_user(message)
    link_to user.name, user, :class => "inner_link"
  end
  
  def message_subject(message)
    link_to message.subject, message_path(message), class: "#{message.opened? ? 'read' : 'unread'}"
  end
  
  def truncated_subject(message)
    message.subject.length > SUBJECT_CUTOFF ? "#{message.subject.slice(0, SUBJECT_CUTOFF)}..." : message.subject
  end

  def find_new_message_path(recipient)
    if recipient
      user_messages_path(recipient)
    else
      messages_path
    end
  end
  
  def mailbox_title
    if params[:mailbox]
      "Your Inbox #{'>> ' + params[:mailbox].capitalize if params[:mailbox] == "archive"}"
    else
      "Your Messages"
    end
  end
  
  def long_message(message)
    message.body.length > MSG_CUTOFF
  end
  
  def message_body_preview(message)
    message_body = sanitize(message.body, tags: [])
    long_message(message) ? message_body.slice(0, MSG_CUTOFF).strip << "..." : message_body
  end
  
  def htmlize_body(message)
    contains_no_html = sanitize(message.body, tags: %w{}) == message.body
    if contains_no_html
      body = message.body.split("\n").map(&:strip).reject(&:blank?).map{|line| "<p>#{line}</p>" }.join
    else
      body = sanitize(message.body, tags: %w{p ul li a})
    end
    body.html_safe
  end
  
  def message_action_options(message)
    options = []
    if message.deleted
      options << ["Move to Inbox", message_path(message, :deleted => false), {:class => "unarchive"}]
    else
      options << ["Archive", message_path(message), {:class => "archive"}]
    end
    if message.opened?
      options << ["Mark as unread", message_path(message), {:class => "mark_unread"}]
    else
      options << ["Mark as read", message_path(message), {:class => "mark_read"}]
    end
    options
  end
  
  def message_edit_options
    [
      ["Archive", "#", {:class => "update_messages archive", :'data-update-attribute' => "deleted", :'data-attribute-value' => true}],
      ["Move to Inbox", "#", {:class => "update_messages unarchive", :'data-update-attribute' => "deleted", :'data-attribute-value' => false}],
      ["Mark as read", "#", {:class => "update_messages opened", :'data-update-attribute' => "opened", :'data-attribute-value' => true}],
      ["Mark as unread", "#", {:class => "update_messages unopened", :'data-update-attribute' => "opened", :'data-attribute-value' => false}]
    ]
  end
  
  def message_opened?(message)
    is_sent_by_current_user = message.is_a?(MessageCopy) && message.sent_messageable == current_user
    (message.opened? || is_sent_by_current_user) && message.messages.inject(true) { |read, m| read && m.read?(current_user) }
  end
end
