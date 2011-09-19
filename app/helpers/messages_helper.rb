module MessagesHelper
  def message_subject(message)
    link_to message.subject, message_path(message), class: "#{message.opened? ? 'read' : 'unread'}"
  end
end
