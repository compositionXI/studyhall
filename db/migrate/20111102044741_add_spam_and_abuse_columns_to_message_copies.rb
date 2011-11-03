class AddSpamAndAbuseColumnsToMessageCopies < ActiveRecord::Migration
  def change
    add_column :message_copies, :spam, :boolean, :null => false, :default => '0'
    add_column :message_copies, :abuse, :boolean, :null => false, :default => '0'
  end
end
