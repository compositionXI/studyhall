class Sharing
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :user_ids, :email_addresses, :message, :object_ids, :share_all, :group_ids

  def initialize(options={})
    self.share_all = true
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def groups
    return [] if group_ids.blank?
    group_ids.delete("")
    Group.find(group_ids)
  end

  def users
    return [] if user_ids.blank?
    user_ids.delete("")
    User.find(user_ids)
  end

  def recipients
    (user_ids || '').split(',') + (email_addresses || '').split(',')
  end

  def recipient_emails
    r = users.map(&:email).join(',')
    r = r + "," if r
    r = r + email_addresses
  end

  # Takes the object_ids string like ",note_1,note_2" and converts it to an array of objects [<Note>,<Note>]
  def objects
    return [] if object_ids.blank?
    object_ids.split(",").select(&:present?).map do |object_id|
      Rails.logger.info "** Sharing: #{object_id}"
      match = object_id.match(/([a-z_]+)_(\d+)/)
      if match[1] && Object.const_defined?(match[1].camelize)
        match[1].camelize.constantize.find(match[2])
      else
        raise ArgumentError.new("Invalid object identifier for group delete: #{identifier}")
      end
    end
  end

  def valid?
    recipients.any? && objects.any?
  end

  def persisted?
    false
  end

end
