class RemoveUserRoleFromUsers < ActiveRecord::Migration
  def up
    if User.column_names.include? "user_role_id"
      remove_column  :users, :user_role_id
    end
  end

  def down
    add_column :users, :user_role_id, :integer
  end
end
