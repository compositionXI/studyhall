class Sharing
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :user_ids, :email_addresses, :message, :object_ids, :share_all

  def initialize(options={})
    self.share_all = true
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def users
    return [] if user_ids.blank?
    User.find(user_ids)
  end

  def recipients
    (user_ids || '').split(',') + (email_addresses || '').split(',')
  end

  def recipient_emails
    [users.map(&:email).join(','),email_addresses].join(',')
  end

  # Takes the object_ids string like ",note_1,note_2" and converts it to an array of objects [<Note>,<Note>]
  def objects
    return [] if object_ids.blank?
    object_ids.split(",").select(&:present?).map do |object_id|
      Rails.logger.info object_id
      match = object_id.match(/([a-z_]+)_(\d+)/)
      if match[1] && Object.const_defined?(match[1].camelize)
        match[1].camelize.constantize.find(match[2])
      else
        raise ArgumentError.new("Invalid object identifier for group delete: #{identifier}")
      end
    end
  end

  def valid?
    recipients.any? && message.present? && objects.any?
  end

  def persisted?
    false
  end

end
