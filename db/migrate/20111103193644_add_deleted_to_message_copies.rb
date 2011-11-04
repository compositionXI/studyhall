class AddDeletedToMessageCopies < ActiveRecord::Migration
  def change
    add_column :message_copies, :deleted, :boolean, :default => false
  end
end
