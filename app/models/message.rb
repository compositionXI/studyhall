class Message < ActiveRecord::Base
  has_attached_file :attachment
  
  class HasMailbox::Models::Message
    has_attached_file :attachment
  end
end