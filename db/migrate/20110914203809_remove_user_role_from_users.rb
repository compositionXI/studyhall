class RemoveUserRoleFromUsers < ActiveRecord::Migration
  def up
    if User.column_names.include? "role"
      remove_column  :users, :role
    end
  end

  def down
    add_column :users, :role, :string
  end
end
