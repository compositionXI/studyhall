class CreateMembersGroupsJoinTable < ActiveRecord::Migration
  def change
    create_table :members_groups, :id => false do |t|
      t.integer :user_id
      t.integer :group_id
    end
  end
end
