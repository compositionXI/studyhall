class AddSpamAndAbuseColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :spam, :boolean, :null => false, :default => '0'
    add_column :messages, :abuse, :boolean, :null => false, :default => '0'
  end
end
