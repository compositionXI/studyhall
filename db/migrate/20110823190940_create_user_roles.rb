class CreateUserRoles < ActiveRecord::Migration
  def up
    create_table :user_roles do |t|
      t.string :name
      t.timestamps
    end
  end
  def down
  end
end
