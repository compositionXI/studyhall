class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :comment_id
      t.string :message
      t.boolean :root

      t.timestamps
    end
  end
end
