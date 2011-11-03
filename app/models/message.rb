class Message < ActiveRecord::Base
  has_attached_file :attachment
  
  class HasMailbox::Models::Message
    has_attached_file :attachment
    
    attr_accessible :spam, :abuse
  end
end