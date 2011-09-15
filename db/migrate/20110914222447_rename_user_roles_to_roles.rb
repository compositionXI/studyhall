class RenameUserRolesToRoles < ActiveRecord::Migration
  def up
    rename_table :user_roles, :roles
  end

  def down
    rename_table :roles, :user_roles
  end
end
