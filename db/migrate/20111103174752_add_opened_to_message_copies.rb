class AddOpenedToMessageCopies < ActiveRecord::Migration
  def change
    add_column :message_copies, :opened, :boolean, :default => false
  end
end
