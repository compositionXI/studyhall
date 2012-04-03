class Broadcast < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  serialize :args, Hash

  def link
    case self.intent.to_sym
    when :studyhall_created
      link = study_sessions_path(:clear_broadcasts => true)
    when :message_sent
      link = mailbox_path(:mailbox => "inbox", :clear_broadcasts => true)
    end
    link
  end

end
