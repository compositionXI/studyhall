module MessagesHelper
  
  MSG_CUTOFF = 80
  SUBJECT_CUTOFF = 30
  
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
    message_body = message.body
    message_body = long_message(message) ? message_body.slice(0, MSG_CUTOFF).strip << "..." : message_body
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
  
  def message_edit_options
    [
      ["Archive", "#", {:class => "update_messages archive", :'data-update-attribute' => "deleted", :'data-attribute-value' => true}],
      ["Move to Inbox", "#", {:class => "update_messages unarchive", :'data-update-attribute' => "deleted", :'data-attribute-value' => false}],
      ["Mark as read", "#", {:class => "update_messages opened", :'data-update-attribute' => "opened", :'data-attribute-value' => true}],
      ["Mark as unread", "#", {:class => "update_messages unopened", :'data-update-attribute' => "opened", :'data-attribute-value' => false}]
    ]
  end
end