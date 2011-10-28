module MessagesHelper
  def message_subject(message)
    link_to message.subject, message_path(message), class: "#{message.opened? ? 'read' : 'unread'}"
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
      "Your #{params[:mailbox].capitalize}"
    else
      "Your Messages"
    end
  end
  
  def long_message(message)
    message.body.length > 125
  end
  
  def message_body_preview(message)
    message_body = message.body
    message_body = long_message(message) ? message_body.slice(0, 125).strip << "..." : message_body
    message_body
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
end