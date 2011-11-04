class Message < ActiveRecord::Base
  has_attached_file :attachment
  
  has_many :messages, :foreign_key => :parent_id
  belongs_to :parent, :class_name => "Message"
  after_save :update_replies
  
  def reply?
    !self.parent_id.nil?
  end
  
  def from
    User.find(self.sender_id)
  end
  
  def update_replies
    parent_message = self
    parent_message.messages.each do |reply|
      reply.update_attributes({:opened => parent_message.opened, :deleted => parent_message.deleted})
    end
    true
  end
  
  class HasMailbox::Models::Message
    has_attached_file :attachment
    attr_accessible :spam, :abuse, :parent_id
  end
end