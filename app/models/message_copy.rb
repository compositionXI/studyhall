class MessageCopy < ActiveRecord::Base
  has_attached_file :attachment
  class HasMailbox::Models::MessageCopy
    has_attached_file :attachment
  end
end