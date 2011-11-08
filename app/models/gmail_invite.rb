require 'contacts'

class GmailInvite

  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :password, :name, :friends, :message, :recipients, :errors

  def initialize(options={})
    self.errors = []
    self.friends = []
    self.recipients = []
    self.message = "Hey, let's study together!"
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def find_friends
    begin
      self.friends = prep_contacts(Contacts::Gmail.new(email, password).contacts)
    rescue Contacts::AuthenticationError => e
      Rails.logger.info("Failed to authenticate #{email} with Gmail")
      self.errors << "Your email address or password is invalid."
      false
    end
  end

  def send_invites
    if recipients.empty?
      self.errors << "You haven't selected any contacts to invite."
      return false
    end
    recipients.each do |recipient|
      Notifier.gmail_invite(name, message, recipient).deliver
    end
  end

  def persisted?
    friends.any?
  end

  def id
    persisted? ? 1 : nil
  end

  private

    def prep_contacts(contacts)
      sort_contacts(remove_nameless_contacts(contacts))
    end

    def remove_nameless_contacts(contacts)
      contacts.select {|contact| contact.first.present? }
    end

    def sort_contacts(contacts)
      contacts.sort_by(&:first)
    end

end
