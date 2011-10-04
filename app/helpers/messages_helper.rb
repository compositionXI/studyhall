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
end
