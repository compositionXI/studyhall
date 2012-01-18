class SetDefaultValueForFollowingBlockedColumn < ActiveRecord::Migration
  def up
    change_column :followings, :blocked, :boolean, :default => false
  end

  def down
    change_column :followings, :blocked, :boolean
  end
end
