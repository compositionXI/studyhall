class SessionSharing

  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email_addresses, :message_body, :sender_id, :study_session_ids

  def initialize(options={})
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def persisted?
    false
  end

end
