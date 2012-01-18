class MessageCopy < ActiveRecord::Base
  has_attached_file :attachment
  
  has_many :messages, :foreign_key => :parent_id, :class_name => "MessageCopy"
  belongs_to :sent_messageable, :class_name => "User", :foreign_key => "sent_messageable_id"
  belongs_to :parent, :class_name => "MessageCopy"
  after_save :update_replies
  
  def read?(user)
    self.sent_messageable == user || opened?
  end
  
  def reply?
    !self.parent_id.nil?
  end
  
  def from
    User.find_by_id(self.sent_messageable_id)
  end
  
  def to
    User.find_by_id(self.recipient_id)
  end
  
  def update_replies
    parent_message = self
    parent_message.messages.each do |reply|
      reply.update_attributes({:opened => parent_message.opened, :deleted => parent_message.deleted})
    end
    true
  end
  
  def sender_id
    self.sent_messageable_id
  end
  
  class HasMailbox::Models::MessageCopy
    has_attached_file :attachment
    attr_accessible :spam, :abuse, :parent_id
  end
end
