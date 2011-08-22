class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
  end
  
  def self.down
  remove_column :students, :city
  end
end
