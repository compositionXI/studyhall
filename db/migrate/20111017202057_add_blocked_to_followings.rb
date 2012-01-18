class AddBlockedToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :blocked, :boolean
  end
end
