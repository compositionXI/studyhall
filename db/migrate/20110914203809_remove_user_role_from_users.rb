class RemoveUserRoleFromUsers < ActiveRecord::Migration
  def up
    remove_column  :users, :role
  end

  def down
    add_column :users, :user_role_id
  end
end
