class AddSharingPrivacyNotificationColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shares_with_everyone, :boolean, :null => false, :default => '1'
    add_column :users, :googleable, :boolean, :null => false, :default => '1'
    add_column :users, :notify_on_follow, :boolean, :null => false, :default => '1'
    add_column :users, :notify_on_comment, :boolean, :null => false, :default => '1'
    add_column :users, :notify_on_share, :boolean, :null => false, :default => '1'
    add_column :users, :notify_on_invite, :boolean, :null => false, :default => '1'
  end
end