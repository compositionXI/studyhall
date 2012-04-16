class Broadcast < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  serialize :args, Hash

  def link
    case self.intent.to_sym
    when :studyhall_created
      link = study_sessions_path(:clear_broadcasts => true)
    when :message_sent
      link = mailbox_path(:mailbox => "inbox", :clear_broadcasts => true)
    when :class_post
      link = class_path(:id => self.args[:course_id])
    end
    link
  end

end
