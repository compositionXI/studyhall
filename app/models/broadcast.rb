class Broadcast < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  serialize :args, Hash

  def link
    case self.intent.to_sym
    when :studyhall_created
      link = study_sessions_path
    when :message_sent
      link = mailbox_path(:mailbox => "inbox")
    end
    link
  end

end
