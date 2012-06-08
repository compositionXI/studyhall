class AddTypeToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :type, :string
  end
  def down
    remove_column :posts, :type
  end
end
